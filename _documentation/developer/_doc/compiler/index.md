---
layout: default
title: Writing a compiler
nav_order: 4
permalink: /compiler/
---

{% include analytics.html category="developer_compiler" %}

# Writing a compiler

A compiler plugin implements [Compiler][compiler]{:target="_blank"}, usually by extending
[AbstractCompiler][abstractCompiler]{:target="_blank"}. The bundled compilers use the
[ANTLR][antlr]{:target="_blank"} parser generator; emuStudio supplies its runtime.

Like every plugin root class, the compiler class must have the [PluginRoot][pluginRoot]{:target="_blank"} annotation.

Sample implementation of a compiler might look as follows (just some methods are implemented):

{:.code-example}
```java
@PluginRoot(
        type = PLUGIN_TYPE.COMPILER,
        title = "Sample compiler",
        description = "Sample compiler"
)
public class CompilerImpl extends AbstractCompiler {
    private final static Logger LOGGER = LoggerFactory.getLogger(CompilerImpl.class);
    private final static List<FileType> SOURCE_FILE_TYPES = List.of(
            new FileType("Assembler source file", "asm")
    );

    private MemoryContext<Byte> memory;

    public CompilerImpl(long pluginID, ApplicationApi applicationApi, PluginSettings settings) {
        super(pluginID, applicationApi, settings);
    }

    @Override
    public void initialize() {
        Optional.ofNullable(applicationApi.getContextPool()).ifPresent(pool -> {
            try {
                memory = pool.getMemory(pluginID, Byte.class);
            } catch (ContextNotFoundException e) {
                LOGGER.warn("Memory is not available", e);
            }
        });
    }

    @Override
    protected void compile(Path inputPath, Path outputPath) throws Exception {
        String fileName = inputPath.toString();
        try (Reader reader = Files.newBufferedReader(inputPath, StandardCharsets.UTF_8)) {
            SampleLexer lexer = createLexer(CharStreams.fromReader(reader));
            lexer.addErrorListener(new ParserErrorListener(fileName));
            CommonTokenStream tokens = new CommonTokenStream(lexer);

            SampleParser parser = createParser(tokens);
            parser.addErrorListener(new ParserErrorListener(fileName));

            Program program = new Program(); // TODO: Create your AST
            program.setFileName(fileName);
            new CreateProgramVisitor(program).visit(parser.rStart()); // TODO: Create AST creator visitor

            IntelHEX hex = new IntelHEX();
            NodeVisitor[] visitors = new NodeVisitor[]{
                    // TODO: create your semantic analysis and code generating visitors
            };
            for (NodeVisitor visitor : visitors) {
                visitor.visit(program);
            }

            if (!program.env().hasNoErrors()) {
                for (CompileError error : program.env().getErrors()) {
                    error(error.position, error.msg);
                }
                return;
            }

            hex.generate(outputPath);
            int programLocation = hex.findProgramLocation();
            applicationApi.setProgramLocation(programLocation);
            info(String.format(
                    "Compile was successful.\n\tOutput: %s\n\tProgram starts at 0x%s",
                    outputPath, Numbers.formatHex(programLocation, 4)
            ));

            if (memory != null) {
                hex.loadIntoMemory(memory);
                info("Compiled file was loaded into memory.");
            } else {
                warning("Memory is not available.");
            }
        }
    }

    @Override
    protected String getOutputExtension() {
        return "hex";
    }

    @Override
    public LexicalAnalyzer createLexer() {
        return new LexicalAnalyzerImpl(createLexer(null));
    }

    @Override
    public List<FileType> getSourceFileTypes() {
        return SOURCE_FILE_TYPES;
    }

    private SampleLexer createLexer(CharStream input) {
        return null; // TODO: create your lexer
    }

    private SampleParser createParser(TokenStream tokenStream) {
        return null; // TODO: create your parser
    }
}
```

The sample uses ANTLR to generate a lexer and parser from the plugin author's grammar. It writes Intel HEX output and
loads it into memory when a compatible context is available. The plugin author supplies the abstract syntax tree
(AST), semantic-analysis visitors, and code generation.

The compiler does not register any plugin context, but when initialized, it obtains optional memory context (in this example,
memory must have cells of `Byte` type). If the memory is available, after compilation the program will be
loaded in the memory.

`AbstractCompiler` implements the public `compile(Path inputPath, Optional<Path> outputPath)` as a template method. It
notifies listeners about the start, reports the compiler title and version, and derives a missing output path from the
input by replacing a source extension with `getOutputExtension()` (or appending it). Then it calls the plugin's
`compile(Path input, Path output)` and notifies listeners about the finish, even on failure. A thrown
`CompileException` is reported as an error at its position; any other exception is reported as a compilation error.
Inside `compile`, report messages with `error(...)`, `warning(...)` and `info(...)`. Error positions are
`SourceCodePosition` objects containing the source filename, line, and column, including for errors in included files.

`AbstractCompiler.runCommandLine(jarName, args, CompilerImpl::new)` implements a command-line interface
(`[-o outputFile] inputFile`, `--version`, `--help`) and returns the exit code, so a launcher class only needs
`System.exit(AbstractCompiler.runCommandLine("as-sample", args, CompilerImpl::new))`.

`AbstractCompiler` reads version and copyright from the plugin's `version.properties` resource as described in
[plugin metadata]({{ site.baseurl }}/plugin_basics/#version-and-copyright-metadata).

After successfully loading generated code, publish all source positions through the live engine returned by
`applicationApi.getAnnotations()`. The bundled 8080 and Z80 assemblers replace their plugin-owned entries in one
`replaceOwner` call, including mappings for included files. Failed compilation leaves previous mappings intact, and
replacement preserves user annotations and other owners' entries. See
[annotations]({{ site.baseurl }}/memory/#cell-type-size-and-annotations) for the API and address semantics.

### Source-position coordinates

Compilers that emit source annotations declare their column unit through `getSourcePositionColumnUnit()`:

```java
@Override
public SourceCodePosition.ColumnUnit getSourcePositionColumnUnit() {
    return SourceCodePosition.ColumnUnit.CODE_POINT;
}
```

`CODE_POINT` matches the bundled 8080/Z80 assemblers, whose ANTLR `CharStreams` count Unicode code points.
Use `UTF16` when columns count Java `String` code units. Either declaration requires one-based lines, zero-based
columns, and tabs counting as one column. The default is `UNKNOWN`: the host reports a diagnostic and excludes these
positions from current source bindings. Lexical `Token` offsets always use UTF-16, independently of compiler columns.

The host resolves positions against the exact captured source text, retaining file identity, source revision, and CRLF
offsets. Included files need their own captured text; equal basenames do not identify the same document. Invalid or EOF
coordinates produce diagnostics instead of clamped bindings. A point annotation covers one generated cell; it does not
prove an instruction's full extent. Its source span is the exact resolved token, or one valid UTF-16 code unit when no
token extent is available. Gaps remain unmapped.

Lexer and parser are not shown here, but they are created using mentioned [ANTLR][antlr]{:target="_blank"}
parser generator. Please check out this nice [ANTLR tutorial][antlr-tutorial]{:target="_blank"}.

The compiler utilizes a helper class [IntelHEX][intelhex]{:target="_blank"} from emuLib for generating output files.

Build an abstract syntax tree (AST) from the parse tree, then transform it through passes. Semantic analysis resolves labels, checks types and operands,
and transforms nodes into a form suitable for code generation. The AST can omit grammar-only details; it does not
need to have the parse tree’s structure. Later passes may replace, move or remove nodes before producing binary code
or the compiler’s other output.

Visitors can separate AST transformations into independently testable passes (see the
[Visitor pattern][visitor]{:target="_blank"}). Each visitor handles selected node types and transforms those nodes
or the whole tree.

For more information, see the code of some existing compilers.

## Lexical analyzer

emuStudio application uses standardized token types in order to support syntax highlighting in general, for any compiler
kind. It is thus required to provide a lexer which returns emuStudio-like token types:

```java
public interface LexicalAnalyzer {
    Token next();

    boolean hasNext();

    void reset(char[] array, int offset, int length);

    // ... optional default methods for editing metadata (see below)
}
```

For ANTLR lexers, extend `AntlrLexicalAnalyzer` and supply a map converting ANTLR token types into the standardized
`Token` types, plus the line comment opening text (or `null`):

```java
public class LexicalAnalyzerImpl extends AntlrLexicalAnalyzer {
    public static final int[] tokenMap = new int[SampleLexer.EOL + 1]; // EOL has the highest number in this case

    static { // TODO: not complete
        tokenMap[COMMENT] = Token.COMMENT;
        tokenMap[EOL] = Token.WHITESPACE;
        tokenMap[WS] = Token.WHITESPACE;

        tokenMap[OPCODE_ADC] = Token.RESERVED;
        tokenMap[PREP_ORG] = Token.PREPROCESSOR;
        tokenMap[REG_A] = Token.REGISTER;
        tokenMap[SEP_COMMA] = Token.SEPARATOR;
        tokenMap[OP_ADD] = Token.OPERATOR;
        tokenMap[LIT_NUMBER] = Token.LITERAL;
        tokenMap[LIT_STRING] = Token.LITERAL;
        tokenMap[ID_IDENTIFIER] = Token.IDENTIFIER;
        tokenMap[ID_LABEL] = Token.LABEL;
        tokenMap[ERROR] = Token.ERROR;
    }

    public LexicalAnalyzerImpl(SampleLexer lexer) {
        super(lexer, tokenMap, ";");
    }
}
```

The `net.emustudio.emulib.plugins.compiler.antlr` package provides further ANTLR helpers. `CharArrayCharStream` reads
the specified slice without copying it, so keep that array unchanged while lexing. `ParserErrorListener(fileName)`
turns syntax errors into a `CompileException` with the source position. `ParsingUtils` provides number parsing
(`parseNumber`, using `Numbers.parseRadix` syntax), quoted-string parsing, label extraction, and identifier
normalization. Grammar, AST, semantic analysis, and code generation remain the compiler plugin's responsibility.

The host retains exact compiler input text and source revisions to validate source mappings. These mappings describe
generated cell coverage and source provenance; debugger memory inspection reads current cells.

### Generic editing metadata

The desktop editor consumes generic token categories and optional `LexicalAnalyzer` operations. Keep assembler keywords,
grammar rules, symbol scopes, and extraction logic inside the compiler plugin. Existing implementations work through
default methods and need not support semantic editing.

| Contract | Meaning |
| --- | --- |
| `Token.BLOCK_START`, `Token.BLOCK_END` | Properly nested block boundaries used by folding and reindentation. |
| `Token.SYMBOL_DEFINITION`, `Token.SYMBOL_REFERENCE` | Declaration and use of a named symbol in a source-analysis snapshot. |
| `Token.INCLUDE_PATH`, `getReferencedFile()` | A token identifying another source file, resolved relative to the containing file. |
| `getSymbolName()` | Spelling beginning at the token offset, without punctuation such as a label's trailing colon. |
| `getSymbolScope()` | Stable lexical scope identity; empty string is the source/include global scope; `null` means unknown. |
| `getReferenceScope()` | Scope in which a reference is resolved, followed by the global scope. Defaults to its lexical scope. |
| `getLineCommentStartAndEnd()` | Opening delimiter and optional closing delimiter, or `null` if comment toggling is unsupported. |
| `analyze(String)` | Immutable tokens for a whole source snapshot, optionally enriched with semantic metadata. |
| `isValidSymbolName(String)`, `normalizeSymbolName(String)` | Language-specific name validation and canonical comparison. |
| `getExtractionKinds()`, `extract(...)` | Optional compiler-owned extraction operations returning edited source for preview. |

Offsets use UTF-16 code units, matching Java String and Swing document indices. `SourceToken` is an immutable carrier for
these fields. The default `analyze` copies lexical tokens into immutable snapshots; semantic implementations must validate
their source before emitting declarations/references. Return unknown metadata instead of guessing a binding.

The editor resolves definitions and references by scope and normalized spelling, traverses include paths, previews edits,
and checks source snapshots again before applying them. It rejects ambiguous declarations, name conflicts, repeated/cyclic
includes, and local-scope includes. Symbols whose scope is unknown cannot be renamed safely. Compiler analysis must not
compile into memory, write output files, or depend on the desktop GUI.

The 8080 and Z80 plugins supply macro/global/local symbol metadata and macro/subroutine extraction. RAM and RASP supply
global labels. Brainc supplies loop block markers. Folding also supports generic indentation, multiline comments, and
explicit editor regions, independent of compiler keywords.


[compiler]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugins/compiler/Compiler.html
[abstractCompiler]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugins/compiler/AbstractCompiler.html
[intelhex]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/runtime/io/IntelHEX.html
[antlr]: https://www.antlr.org/
[antlr-tutorial]: https://tomassetti.me/antlr-mega-tutorial/
[visitor]: https://refactoring.guru/design-patterns/visitor
[pluginRoot]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugins/annotations/PluginRoot.html

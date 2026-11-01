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
        title = "Sample compiler"
)
public class CompilerImpl extends AbstractCompiler {
    private final static Logger LOGGER = LoggerFactory.getLogger(CompilerImpl.class);
    private final static List<FileExtension> SOURCE_FILE_EXTENSIONS = List.of(
            new FileExtension("asm", "Assembler source file")
    );

    private MemoryContext<Byte> memory;

    public CompilerImpl(long pluginID, ApplicationApi applicationApi, PluginSettings settings) {
        super(pluginID, applicationApi, settings);
    }

    @SuppressWarnings("unchecked")
    @Override
    public void initialize() throws PluginInitializationException {
        Optional.ofNullable(applicationApi.getContextPool()).ifPresent(pool -> {
            try {
                memory = pool.getMemoryContext(pluginID, MemoryContext.class);
                if (memory.getCellTypeClass() != Byte.class) {
                    throw new InvalidContextException(
                            "Unexpected memory cell type. Expected Byte but was: " + memory.getCellTypeClass()
                    );
                }
            } catch (InvalidContextException | ContextNotFoundException e) {
                memory = null;
                LOGGER.warn("Memory is not available", e);
            }
        });
    }

    @Override
    public void compile(Path inputPath, Optional<Path> outputPath) {
        notifyCompileStart();
        notifyInfo(getTitle() + ", version " + getVersion());

        Path finalOutputPath = outputPath.orElse(convertInputToOutputPath(inputPath, ".hex"));
        try (Reader reader = Files.newBufferedReader(inputPath, StandardCharsets.UTF_8)) {
            SampleLexer lexer = createLexer(CharStreams.fromReader(reader));
            lexer.addErrorListener(new ParserErrorListener());
            CommonTokenStream tokens = new CommonTokenStream(lexer);

            SampleParser parser = createParser(tokens);
            parser.addErrorListener(new ParserErrorListener());

            Program program = new Program(); // TODO: Create your AST
            program.setFileName(inputPath.toString());
            new CreateProgramVisitor(program).visit(parser.rStart()); // TODO: Create AST creator visitor

            IntelHEX hex = new IntelHEX();
            NodeVisitor[] visitors = new NodeVisitor[]{
                    // TODO: create your semantic analysis and code generating visitors
            };

            for (NodeVisitor visitor : visitors) {
                visitor.visit(program);
            }

            if (program.env().hasNoErrors()) {
                hex.generate(finalOutputPath);
                int programLocation = hex.findProgramLocation();
                applicationApi.setProgramLocation(programLocation);

                notifyInfo(String.format(
                        "Compile was successful.\n\tOutput: %s\n\tProgram starts at 0x%s",
                        finalOutputPath, RadixUtils.formatWordHexString(programLocation)
                ));

                if (memory != null) {
                    hex.loadIntoMemory(memory, b -> b);
                    notifyInfo("Compiled file was loaded into memory.");
                } else {
                    notifyWarning("Memory is not available.");
                }
            } else {
                for (CompileError error : program.env().getErrors()) {
                    notifyError(error.position, error.msg);
                }
            }
        } catch (CompileException e) {
            notifyError(e.position, e.getMessage());
        } catch (IOException e) {
            notifyError("Compilation error: " + e);
        } finally {
            notifyCompileFinish();
        }
    }

    @Override
    public LexicalAnalyzer createLexer() {
        return new LexicalAnalyzerImpl(createLexer(null));
    }

    @Override
    public List<FileExtension> getSourceFileExtensions() {
        return SOURCE_FILE_EXTENSIONS;
    }

    @Override
    public String getDescription() {
        return "Sample compiler";
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

`compile(Path inputPath, Optional<Path> outputPath)` reports results through compiler listeners. Use
`convertInputToOutputPath(inputPath, ".hex")` when no output path is supplied, and always pair `notifyCompileStart()`
with `notifyCompileFinish()` in a `finally` block. Error positions are `SourceCodePosition` objects containing the
source filename, line, and column, including for errors in included files.

`AbstractCompiler` reads version and copyright from the plugin's `version.properties` resource as described in
[plugin metadata]({{ site.baseurl }}/plugin_basics/#version-and-copyright-metadata).

After loading generated code, attach source positions through `memory.annotations()`. The bundled 8080 and Z80
assemblers remove annotations owned by their plugin ID and add positions for generated addresses, including included
files. See [memory annotations]({{ site.baseurl }}/memory/#cell-type-size-and-annotations) for ownership and invalidation.

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
public interface LexicalAnalyzer extends Iterable<Token> {
    Token next();

    boolean hasNext();

    void reset(char[] array, int offset, int length);
}
```

The implementation is usually manual, tokens generated by ANTLR are converted into the standardized variants, e.g.:

```java
public class LexicalAnalyzerImpl implements LexicalAnalyzer {
    public static final int[] tokenMap = new int[SampleLexer.EOL + 1]; // EOL has the highest number in this case

    static { // TODO: not complete
        tokenMap[COMMENT] = Token.COMMENT;
        tokenMap[EOL] = Token.WHITESPACE;
        tokenMap[WS] = Token.WHITESPACE;
        
        tokenMap[OPCODE_ADC] = Token.RESERVED;
        tokenMap[OPCODE_AND] = Token.RESERVED;
        tokenMap[OPCODE_ADD] = Token.RESERVED;
        
        tokenMap[PREP_ORG] = Token.PREPROCESSOR;
        tokenMap[PREP_EQU] = Token.PREPROCESSOR;
        tokenMap[PREP_VAR] = Token.PREPROCESSOR;
        
        tokenMap[REG_A] = Token.REGISTER;
        tokenMap[REG_B] = Token.REGISTER;
        tokenMap[REG_C] = Token.REGISTER;
        
        tokenMap[SEP_LPAR] = Token.SEPARATOR;
        tokenMap[SEP_RPAR] = Token.SEPARATOR;
        tokenMap[SEP_COMMA] = Token.SEPARATOR;
        
        tokenMap[OP_ADD] = Token.OPERATOR;
        tokenMap[OP_SUBTRACT] = Token.OPERATOR;
        tokenMap[OP_MULTIPLY] = Token.OPERATOR;
        tokenMap[OP_DIVIDE] = Token.OPERATOR;
        
        tokenMap[LIT_NUMBER] = Token.LITERAL;
        tokenMap[LIT_HEXNUMBER] = Token.LITERAL;
        tokenMap[LIT_OCTNUMBER] = Token.LITERAL;
        tokenMap[LIT_STRING] = Token.LITERAL;

        tokenMap[ID_IDENTIFIER] = Token.IDENTIFIER;
        tokenMap[ID_LABEL] = Token.LABEL;

        tokenMap[ERROR] = Token.ERROR;
    }

    private final SampleLexer lexer;
    
    public LexicalAnalyzerImpl(SampleLexer lexer) {
        this.lexer = Objects.requireNonNull(lexer);
    }

    @Override
    public Token next() {
        org.antlr.v4.runtime.Token token = lexer.nextToken();
        return new Token() {
            @Override
            public int getType() {
                return convertLexerTokenType(token.getType());
            }

            @Override
            public int getOffset() {
                return token.getStartIndex();
            }

            @Override
            public String getText() {
                return token.getText();
            }
        };
    }

    @Override
    public boolean hasNext() {
        return !lexer._hitEOF;
    }

    @Override
    public void reset(char[] array, int offset, int length) {
        lexer.setInputStream(new CharArrayCharStream(array, offset, length));
    }


    private int convertLexerTokenType(int tokenType) {
        if (tokenType == EOF) {
            return Token.EOF;
        }
        return tokenMap[tokenType];
    }
}
```

`CharArrayCharStream` and literal parsing helpers are provided by `net.emustudio.emulib.plugins.compiler.antlr`.
The stream reads the specified slice without copying it, so keep that array unchanged while lexing. `ParsingUtils`
provides numeric and quoted-string parsing, label extraction, and identifier normalization. Grammar, AST, semantic
analysis, and code generation remain the compiler plugin's responsibility.

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

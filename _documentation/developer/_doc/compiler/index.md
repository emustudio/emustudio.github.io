---
layout: default
title: Writing a compiler
nav_order: 4
permalink: /compiler/
---

{% include analytics.html category="developer_compiler" %}

# Writing a compiler

A compiler plugin must either implement [Compiler][compiler]{:target="_blank"} interface, or extend more
bloat-free [AbstractCompiler][abstractCompiler]{:target="_blank"} class. Common practice is to utilize
[ANTLR][antlr]{:target="_blank"} parser generator, which has a direct runtime support in emuStudio.

As every plug-in root class, compiler class must use annotation [PluginRoot][pluginRoot]{:target="_blank"}.

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

Main outcomes are:
- this sample compiler uses ANTLR to generate a lexer and parser from a grammar written by the plugin author
- it optionally loads program output into memory
- it generates output file in Intel HEX format
- AST (abstract syntax tree) in form of classes must be written manually
- All semantic-analysis visitors must be written manually, including code generation (this is probably the hardest compiler work) 

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

Abstract syntax tree is the most important part of the compiler. In general, the flow of transforming the source code
into output is going through AST. In the beginning, AST is isomorphic to the parse tree. Then some transformations are
applied - like expression evaluation, include files expansion, by-value identifiers replacements, intermediate code generation
with relative addresses, macro expansion, preprocessor code evaluation, absolute address assignment and final
transformation into binary code or whatever the compiler produces. So in time, AST changes, nodes are moved, replaced
by others, or removed. At the final stage, AST represents program output.

Transformations of AST is best done using visitors (see [Visitor pattern][visitor]{:target="_blank"}). A visitor is accepting
some or all node types from the AST and performs changes to the nodes, or the whole AST. It's a detached, isolated
functionality operating on AST, which can be separately tested.

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
        tokenMap[ID_LABEL] = Token.IDENTIFIER;

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


[compiler]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugins/compiler/Compiler.html
[abstractCompiler]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugins/compiler/AbstractCompiler.html
[intelhex]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/runtime/io/IntelHEX.html
[antlr]: https://www.antlr.org/
[antlr-tutorial]: https://tomassetti.me/antlr-mega-tutorial/
[visitor]: https://refactoring.guru/design-patterns/visitor
[pluginRoot]: {{ site.baseurl }}/emulib_javadoc/net/emustudio/emulib/plugins/annotations/PluginRoot.html

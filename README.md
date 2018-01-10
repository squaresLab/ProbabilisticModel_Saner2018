# Using a probabilistic model to predict bug fixes
Paper and supporting materials of the Probabilistic Model paper Accepted to SANER 2018:
Documents in this repo:

Model.txt:
Describes the distribution of both replacements and mutation operators used in the
experiments of this paper.
There are 22 types of statements, therefore there are 484 (22 * 22) possible 
combinations of replacements.
The first 484 lines of this file describe this distributions of the replacements.
The order of the statments is:
1. AssertStatement
2. Block
3. BreakStatement 
4. ConstructorInvocation 
5. ContinueStatement 
6. DoStatement
7. EmptyStatement 
8. EnhancedForStatement 
9. ExpressionStatement 
10. ForStatement 
11. IfStatement 
12. LabeledStatement 
13. ReturnStatement 
14. SuperConstructorInvocation 
15. SwitchCase 
16. SwitchStatement 
17. SynchronizedStatement 
18. ThrowStatement 
19. TryStatement 
20. TypeDeclarationStatement 
21. VariableDeclarationStatement 
22. WhileStatement

The order they are sorted is Replacer/Replacee. E.g. Line 1 describes the count
of an AssertStatement replacing another AssertStatement. Line 2 describes the count
of an AssertStatement replacing a Block and so on.

The last 19 lines of this file describe the mutation operator distribution.
3 Coarse grained mutations (Append, Delete, Replace) and 16 Templates as follows:
1. Replacement
2. Append
3. Delete
4. Null Check
5. Param Replacer
6. Method Replacer
7. Param Add/Rem
8. Object Initializer
9. Seq Exchanger
10.	Range Check
11.	Size Check
12.	Lower Bound Set
13.	Upper Bound Set
14.	Off by One
15.	Cast Check
16.	Caster Mutator
17.	Castee Mutator
18.	Expression Replacer
19.	Expression Add/Rem

The AssociationRules folder contains the 10 fold cross validation results
and the transactions files.
ReplacementTransactions and MutOperatorsTransactions are files in csv and arff 
format that describe the frequence of mutation operators and replacements gathered
from the corpus and used to create the association rules.

The scripts are documented internally and have numbers that show the order
in which they should be executed.

The QATestSuites folder contains the held-out test suites used to evaluate quality of the 
patches found. The version of Evosuite used to build this test suites (1.0.3,
latest when this study began) requires Java 8. 

The Patches folder contains the modified patched files. These patches
are built using Java 7 and genprog4java available in the repo:
https://github.com/squaresLab/genprog4java

analyzedRepos.txt shows the git repos that were analyzed to build the corpus
of this paper. These were the most stared projects in August 2016.


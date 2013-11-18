# Table of Contents #

## 1. Background ##

- What is TDD
- Origins of TDD
- When to use TDD

## 2. What vs How ##

- Specification vs Implementation

## 3. Calculator ##
- Learn about assertion

## 4. Canonical Test Structure ##
- What is Canonical Test Structure
- Practice Canonical Test Structure 

## 5. Code Mutation ##
- To illustrate the need to mutate the code when the test passes without failing the first time.

## 6. Eliminate Loops ##
- How to eliminate loops in specs
- Focus on “What” instead of implementation, the “How”

## 7. Role ##
- Being minimal when implementing the production code.

## 8. Fibonacci ##
- To learn TDD Cycle : Red, Green, Refactor.
- Focus on getting it to work first, cleanup by refactoring and then focus on optimization.
- When refactoring, start green and end in green.
- Learn recursive solution and optimize the execution by using non-recursive solution.
- Using existing tests as regression tests when making major changes to existing code.

## 9. Scanner ##
- How to use Fakes and Mocks ?
- When to delete a test ?
- Learn about Open Closed Principle and how to apply it 

## 10. Week ##
- Introduction to Contract tests. 
- How to write Contract tests? 
- Using Contract tests to explicitly document the behavior of an API for invalid inputs.
- Learn about reliable test. A test that fails when it should.

## 11. Guess Game ##
- How to test random behavior ?
- Illustrate inverting dependencies.
- How to make your code depend on abstractions instead of concrete implementation ?
- Illustrate Single Responsibility Principle. No And, Or, or But.
- Illustrate programming to an interface not to an implementation.
- When to use partial stub on a real object ? Illustrated by spec 7 and 8.
- Random test failures due to partial stub. Fixed by isolating the random number generation.
- Make methods small, focused on doing one thing.
- How to defer decisions by using Mocks ?
- Using mock that complies with Gerard Meszaros standard.
- How to use as_null_object ?
- How to write contract specs to keep mocks in sync with production code ?

## 12. Uncommenter ##
- Using fake objects to speed up test

## 13. Test Spy ##
- Using Stubs with Test Spy in Ruby

## 14. Command Query Separation ##
- How to fix violation of Command Query Separation principle  ?
- How to fix abuse of mocks ?
- How to write focused tests ? 
- How to deal with external dependencies in your domain code ?

## 15. Angry Rock ##
- How to fix Command Query Separation violation?
- Refactoring : Retaining the old interface and the new one at the same time to avoid old tests from failing.
- Semantic quirkiness of Well Grounded Rubyist solution exposed by specs.
- Using domain specific terms to make the code expressive

## 16. Bowling Game ##
- Using domain specific term and eliminating implementation details in the spec.
- Focus on the 'What' instead of 'How'. Declarative vs Imperative.
- Fake it till you make it.
- When to delete tests?
- State Verification
- Scoring description and examples were translated to specs.
- BDD style tests read like sentences in a specification. 
- Updating the specs as we learn more about the bowling game instead of blindly appending specs to the existing specs.

## 17. Double Dispatch ##
- Learn how to use double dispatch to make your code object oriented.

## 18. Twitter Client ##
- How to deal with third party API?
- How to use thin adapter layer to insulate domain code from external API?
- What does abusing mocks look like?
- Example of brittle tests that break even when the behavior does not change, caused by mock abuse.
- Integration tests should test the layer that interacts with external API.
- Using too many mocks indicate badly designed API. 

## 19. Learning Specs ##
- Why do we need learning specs?
- How to write learning specs?

## 20. String Calculator ##
- Triangulate to solve the problem
- Experiment to learn and explore possible solution
- Refactoring when there is no duplication to write intent revealing code
- Simplifying method signatures

## Appendix ##
* A. RSpec Test Structure 
* B. Fibonacci Exercise Answer
* C. Interactive Spec
* D. Gist by Pat Maddox at https://gist.github.com/730609
* E. FAQ
* F. Difficulty in Writing a Test
* G. Side Effect
* H. dev/null in Unix 
* I. Stub
* J. Notes from Martin Fowler's article and jMock Home Page
* K. Notes on Mock Objects
* L. Why use mock objects?
* M. A Pattern for Unit Testing
* N. Tautology
* O. Interactive Spec
* P. The Rspec Book
* Q. Direct Input
* R. Indirect Input
* S. Direct Output
* T. Indirect Output
* U. Angry Rock : Possible Solution
* V. Angry Rock : Concise Solution
* W. Double Dispatch : Angry Rock Game Solution

\newpage

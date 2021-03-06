# Chapter 2 : What vs How #
## Example #1 ##

Music sheet is not music. It is description of music. This is the 'What' or Logical Design.

![Music Sheet](../figures/music_sheet)

Music is played using musical instruments. This is the 'How' or the Physical Design. There are many physical designs for a given logical design.

## Example #2 ##

John Lennon wrote the song 'Come Together'. The lyrics is the 'What'. The examples of 'How' in this case are the singing  of this song by:

- The Beatles
- Aerosmith
- Michael Jackson

## Separate What from How ## 

How do you separate 'What' from 'How' in code? Chris Stevenson's TestDox style expresses the subject in the code as part of a sentence.

- A Sheep eats grass
- A Sheep bleats when frightened
- A Sheep produces delicious milk
- A Sheep moves away from sheep dogs

The sentence expresses the behavior of the subject. The subject in this case is the sheep. These sentences can be converted to specifications in code :

```ruby
describe Sheep do
  it 'eats grass'
  it 'bleats when frightened'
  it 'produces delicious milk'
  it 'moves away from sheep dogs'
end
```

When you think about the system from outside-in fashion you focus on intent. You focus on 'what' you are doing rather than the implementation which is the 'how'.

## Exercises ##

Search YouTube and watch the videos for Come Together performed by The Beatles, Michael Jackson, Aerosmith and Elton John

## Summary ##

In this chapter you learned about the difference between specification and implementation. In the next chapter you will learn about assertions.

## References ##

1. InfoQ video - Test Driven Development: Ten Years Later by Michael Feathers and Steve Freeman 



\newpage

---
layout: docs-en
title: "13. Log-Driven Development"
category: Manual
permalink: /manuals/1.0/en/13-vision-ldd.html
---

# Log-Driven Development (LDD)

> "Once Zhuang Zhou dreamt he was a butterfly... Suddenly he awoke and there he was, solid and unmistakable Zhuang Zhou. But he didn't know if he was Zhuang Zhou who had dreamt he was a butterfly, or a butterfly dreaming he was Zhuang Zhou."
> —Zhuangzi, 'The Adjustment of Controversies' (Qi Wu Lun) (Circa 4th Century BC)

> **Note**: This chapter describes the "Future Vision" that Be Framework aims for. Not everything is implemented in the current version.

## Ultimate Transparency

Be Framework aims for a world where there is ultimate transparency in all layers—code, execution, log, and specification—and also where the boundaries between them become ambiguous.

### Reversibility Brought by Three Transparencies

The one-way flow of writing code from specifications, executing it, and outputting logs is the natural order of things (standard). However, Be Framework seeks to explore the possibility of complete "Reversibility" through the following three transparencies:

1.  **Structural Transparency**:
    *   The `#[Be]` attribute explicitly manifests the flow of metamorphosis as the structure of the code itself. This allows drawing the entire specific Decision Graph of the application just by static analysis.
2.  **Semantic Transparency**:
    *   Variable names are not just labels, but contracts. A name like `$email` encompasses validation by the `Email` class and philosophical definitions (like ALPS). This lets you understand the "meaning" and "guarantee" of the data just by looking at the variable name.
3.  **Execution Transparency**:
    *   Semantic logs are not merely "transit records" but record the entire basis of judgment "why that decision was reached".

## Infinite Loop of Value

This transparency enables the "Elimination of Guesswork" by AI.

1.  **Log**: Humans (or AI) write the "story that should be" as a log.
2.  **AI Construction**: AI assembles code not by guesswork but as "work" from that log, relying on structural and semantic transparency.
3.  **Code**: The generated code becomes the definition of Temporal Being.
4.  **Execution**: The code is executed, and a log according to the contract is output.
5.  **Verification**: Confirm that the output log matches the original story (Log) through execution transparency.

Through this cycle, a world where "Dream (Log)" and "Reality (Code)" are mutually and continuously converted is completed.

## Log-Driven Development (LDD)

The new development method brought about by this reversibility is **Log-Driven Development (LDD)**.

### "Code ⇔ Log ⇔ Specification"

Just as TDD (Test-Driven Development) defines "Behavior (Doing)" and then implements it, LDD defines "Story (Log)" and then generates Existence (Code/Being).

1.  **Narrative First**: Developers first write the "Semantic Log that should be". This is the "story" the system should trace, and is itself the DSL (Domain Specific Language) defining the application.
    ```yaml
    UserRegistration:
      - Input: {email: "New User", ...}
        Becomes: ValidatedUser
      - ValidatedUser:
        Becomes: RegisteredUser
    ```
2.  **Specification Generation**: "Specifications (what state transitions are required)" are derived from the log.
3.  **Code Generation**: From the specifications, `#[Be]` chains and class definitions to realize them are automatically generated.

### Future Debugging

In a world where ultimate transparency is realized, debugging becomes synonymous with "reading logs". Non-reproducible bugs do not exist. This is because the log is a complete "executable specification", and just by pouring that log in, the system can Reproduce (Replay) exactly the same metamorphosis process.

## Conclusion: Code as Philosophy

The "Butterfly Dream" at the beginning is an anecdote of the ancient Chinese thinker Zhuangzi.

> He dreamt he was a butterfly, fluttering about... suddenly he awoke... but he didn't know if he was Zhuang Zhou who had dreamt he was a butterfly, or a butterfly dreaming he was Zhuang Zhou.

Digital reality where logs can become code in LDD is exactly this Butterfly Dream, and Be Framework's complete transparency makes the boundary of meaning between log and code ambiguous. Thought becomes word, word becomes code, and code becomes story.

Programming in Be Framework is not merely ordering a computer.
It is an act of defining "Temporal Being" in digital space acting like life, and letting its metamorphosis spin out a meaningful story (Log).

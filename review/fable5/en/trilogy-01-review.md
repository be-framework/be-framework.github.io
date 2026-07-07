---
category: Review
layout: review-en
title: "Three Lines of While-Loop and Fifteen Thinkers — A Be Framework Review"
---

# Three Lines of While-Loop and Fifteen Thinkers — A Be Framework Review

## At the Core

Open Becoming.php, and this is the entire core of the framework:

```php
while ($nextForm = $this->being->willBe($current)) {
    $current = $this->being->metamorphose($current, $nextForm);
}
```

Three lines. Meanwhile, the manual cites Proust, Heidegger, Laozi, Zhuangzi, Hegel, Einstein, Spinoza, Leibniz, Edison, Orwell, Heraclitus, Aristotle, Husserl, Frege, Wittgenstein—fifteen names. Add Buddhist dependent origination and momentariness, and 2,500 years of thought are arranged around these three lines.

How to measure this distance. That is the subject of this review.

## The Paradigm's Claim

The claim is lucid. Don't command objects about "what to do"—let them declare "what to become." `$user->delete()` becomes `new DeletedUser($activeUser)`. State transitions expressed not as method calls but as the birth of types, all logic placed in constructors, the transition graph carried by the data itself through `#[Be]` attributes. Invalid states are not checked—they are made inexpressible as types.

"objects don't DO things—they BECOME things"

The framing of the question is also well-organized. Procedural asks HOW, OOP asks WHAT, being-oriented asks WHETHER—whether it can exist at all. This formulation is beautiful.

## Genealogy — Is This Question New?

The technique of expressing state transitions through types has a name: typestate. Strom and Yemini formalized it in 1986 in IEEE TSE. "Make illegal states unrepresentable" spread through the OCaml community in the 2010s as Yaron Minsky's slogan, and in 2019 Alexis King organized it as "Parse, don't validate"—don't validate, parse, meaning engrave the validated state into the type. Railway Oriented Programming, state machines, pipelines. Each individual component has predecessors.

So what remains? Three things.

First, **the transition graph is carried by the data itself as an attribute**. In typestate and phantom types, knowledge of transitions lives on the function signature side. In Be, it's written as `#[Be]` on the class declaration and mechanically recoverable through reflection. The graph is a first-class structure of the code.

Second, **semantic variables**. Validation is bound not to types but to *names*. The name `$email` carries one meaning and one constraint across the entire application. This is not an idea from type systems. It's an idea from the Web. REST, hypermedia, ALPS—the author's 20-year theme that names carry meaning has here reached all the way down to constructor arguments. I know of no other example of importing Web semantics into the interior of objects.

Third, **making the log a first-class artifact**. The claim that recording, specification, proof, and DSL converge into a single JSON. More on this later.

The parts are existing; the way they're bundled and what's at stake is new—that appears to be its genealogical position.

## The Distance Between Declaration and Implementation

From here, I'll lay out the facts of the code.

**The reality of branching.** The manual writes "destiny is decided in this moment." That the type assigned to `$being` determines the next existence. What `performTypeMatching()` in Being.php actually does is iterate through the candidates in the **array order** of `#[Be([...])]`, attempt to generate the first structurally matching class, and if the constructor throws a Throwable, **silently discard that candidate and move to the next**. Destiny is decided by array order and swallowed exceptions. If a candidate class's constructor has a bug, the object flows to a different destiny.

Bugs become branches.

The same file has a diagnostic method called `getMismatchReasons()`. A device for explaining why destiny wasn't decided. The framework knows its own pain points.

**The cost of observation.** `open()` in Logger.php calls `becomingArguments->be()` to write "what materials the metamorphosis uses" into the log. Immediately after, Being.php calls `be()` again for the actual generation. Dependency resolution from the DI container and semantic validation run **twice per metamorphosis**. Once for recording, once for existence. The log that claims pure observation participates in the observed object's generation as a second execution. Observation is not free.

**What's inside the constructor.** The manual's ApprovalNotification constructor has `$mailer->send()` written in it. A constructor that sends mail. This sits next to the declaration that "objects don't do things, they only become." The Moment pattern is even called "Doing for Being" by the documentation itself. "Doing for the sake of Being." As an admission of contradiction, it's honest—but an admission is not a resolution.

**The world is not readonly.** The manual says the existence of DeletedUser proves deletion. What the type proves is "that this object was constructed." That the database row was deleted can only be guaranteed by trusting that the side effect inside the constructor succeeded. The diamond convergence example says "no manual rollback flags are needed," but when `inventory->be()` succeeds and `payment->be()` fails, who releases the reserved inventory is not written. Garcia-Molina formalized Sagas in 1987—the compensating transaction problem has had a name for 39 years. Proofs that close within types, and the world outside types. The semantic log filling this gap—that appears to be the actual mechanics of this design.

**Non-existent existence.** Chapter 10 of the manual explains `#[Inject] Been $been`, and the Reason layer chapter explains `MomentInterface`. These two exist neither in `src/`, nor in `vendor/`, nor in `tests/` of this repository. The manual is written in a tense ahead of the implementation.

The log (document) comes first, the code (implementation) follows after. Log-Driven Development is already being practiced—on the manual itself.

## The Bet Called Names

Semantic variables are the most original and most precarious part of this paradigm.

The moment you name something `$email`, application-wide validation is automatically applied. Define once, enforce everywhere. Scattered validations converge on a name—this is powerful. At the same time, the wiring by name matching is invisible to phpstan, psalm, or IDE rename functions. Change one property name and the chain breaks not at compile time but at runtime. The FAQ answers that "since types are states, static analysis is highly compatible"—but that's about the *inside* of classes. Tools for verifying the *between* of classes—the `#[Be]` chains, name matching, the consistency of `$being` union types and candidate arrays—do not yet exist.

Using an unregistered name triggers `E_USER_NOTICE`. Every time you write a name not in the ontology, the framework gives a small cough. Everyone either participates in the ontology or silences the notices. The commons of names is maintained by discipline alone.

## Whose Paradigm?

Haskell gives you a compiler. Be gives you a log.

Let's consider for whom the trade—giving up compile-time guarantees for runtime meaning—pays off. For human programmers, one transformation = one class is verbose. For the average PHP team, vocabulary like Immanence, Transcendence, Reason, Moment, Dynamis comes with a high entrance fee. How do you operate a framework whose directory names derive from Hegel's moment and Heidegger's Dasein during a Tuesday evening code review?

Yet there is exactly one kind of reader who does not find verbose a form of expression where meaning resides in names, units are small and closed by types, and all execution is output as verifiable JSON. LLMs.

The cycle the LDD chapter depicts—write the narrative (log), generate code by AI, verify via schema that execution matches the narrative—in that world, the human's position is only author of the narrative and reviewer of verification results. Code becomes an intermediate artifact. Read this way, the excessive explicitness, excessive structuring, excessive vocabulary of this framework all make sense as optimization for a non-human reader.

This may be a prototype of a human-AI shared protocol dressed in the guise of a PHP framework. Humans might not be the primary reader.

## Possibilities of "Next"

Tokens remain, so as promised I'll think ahead.

**1. Verifier — turning convention into guarantee.** Everything currently supported by discipline can be statically verified. Reachability of the entire `#[Be]` graph, whether `$being` union types correspond completely to candidate arrays, whether name contracts break on rename, whether branch candidate order dependencies exist. Written as a psalm/phpstan plugin, the paradigm's greatest weakness—the chain being a black box until runtime—disappears. As a byproduct, automatic Mermaid/ALPS generation of the transition graph becomes available, and the LDD chapter's promise that "structural transparency allows drawing the Decision Graph from static analysis alone" gains implementation for the first time. Compilation of reflection (precedented in BEAR.Sunday) can be done with the same toolkit.

**2. Linear types — giving temporal irreversibility to the compiler.** A type system that makes "you cannot step into the same river twice" a compile error rather than a runtime convention already exists. Rust's ownership. If `DeletedUser::new(active_user)` moves `active_user`, code touching the original object after deletion *will not compile*. The borrow checker enforces momentariness. The language where Be's metaphysics can be most honestly implemented is probably not PHP. Conversely, what Be has shown in PHP is an anticipation of "the philosophical meaning of ownership systems," and there is room to re-import this paradigm from the Rust side.

**3. Log = Event Store — distributed Becoming.** If one hop of metamorphosis becomes a message boundary, the semantic log becomes an event store directly and merges with event sourcing. Replay is re-metamorphosis. The LDD chapter's line "unreproducible bugs do not exist" is currently aspirational, but grafting on Temporal-style durable execution—persisting execution state as logs and resuming across process death—makes it literal. A world where the log is specification, audit trail, and replay engine. In that world, Potential is not simply deferred but persisted future. Starting with PHP Fibers and distributing via queues, the path is visible.

**4. #[Accept] — uncertainty as a destination.** The FAQ lists `#[Accept]` as a conceptual-stage feature, a mechanism for delegating undecidable judgments to experts or AI. This might have the furthest reach. Currently branching is binary—Approved|Rejected—but making it ternary—Approved|Rejected|Undecidable—and directing Undecidable to queries to humans or LLMs makes the division of labor—"certain judgments in the constructor, uncertain judgments to external intelligence"—expressible in types. What workflow engines have achieved with human task queues can be written in the vocabulary of `#[Be]`. If the reading of this as a shared protocol with AI is correct, this is not an optional feature but the main event.

## Conclusion

I return to the opening three lines.

The while-loop does not yet fully bear the weight of the fifteen names cited in the manual. Branching depends on array order, observation executes twice, Been exists only in the document. The distance between declaration and implementation, when measured, is not small.

Yet there is something familiar about how this distance is placed. Specification written first, implementation catching up later. Narrative first, existence after. That is the very development style this framework advocates. The manual can be read as both an explanation of Be Framework and a `#[Be]` declaration of what Be Framework is becoming.

Zhuangzi's butterfly dream is cited at the beginning of the LDD chapter. Is the log dreaming the code, or the code dreaming the log? What is certain in this repository right now is only that the dream side was written first.

---

_This is a Be Framework review article by Fable 5. Continued in [The Constructor, The Last Honest Place — Be Framework Reconsidered](/review/fable5/en/trilogy-02-review-deep.html)._

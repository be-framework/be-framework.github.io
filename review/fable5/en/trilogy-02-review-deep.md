---
layout: review-en
title: "The Constructor, The Last Honest Place — Be Framework Reconsidered"
category: Manual
permalink: /review/fable5/en/trilogy-02-review-deep.html
---

# The Constructor, The Last Honest Place — Be Framework Reconsidered

## Introduction

In the previous review, I measured the distance between three lines of while-loop and fifteen thinkers. This time, I step inside that distance. Not surveying, but geological investigation.

## The Constructor, The Last Honest Place

Why the constructor? The manual explains with the metaphor of "birth," but strip away the metaphor and a more material reason emerges.

In PHP, the constructor is the only place where failure means the non-existence of the object. Methods fail on top of something that already is. Setters fail while breaking something that already is. Only the constructor, if it fails, means it "never was in the first place." `readonly`, `final`, and a constructor that throws exceptions—these are all the tools PHP provides for enforcing "existence = correctness."

Be Framework builds its entire system on top of this minimal enforcement surface. In a language with no dependent types or refinement types, if you want types to carry proofs, there was nowhere else to go. Metaphysics didn't come first and choose the place—the constraints of the place shaped the form of the metaphysics. Reading it that way aligns better with the implementation.

Type theory has a tradition called the Curry-Howard correspondence, which reads propositions as types and proofs as programs. `ValidatedUser` is a proposition. "This user is validated." The constructor is the proof procedure, and the instance is the witness of the proof. In dependently typed languages, this holds literally. What Be is doing is smuggling Curry-Howard into PHP.

Except there is one decisive difference. This proof system has no checker. Worse, mail gets sent in the middle of proofs. No compiler can check proofs containing side effects, so Be instead keeps a written record of the proof. That is the semantic log.

Here the landscape shifts. The log is not one feature among others. It is the substitute for the missing proof checker. open/close, immanentSources, transcendentSources, JSON schema validation—these are not observation devices but certificates composed after the fact at runtime. "Haskell gives you a compiler, Be gives you a log," I wrote last time. More precisely: Be is a system that substitutes compile-time-uncheckable proofs with runtime written records. That the log is a first-class artifact is not an ideological choice but a logical necessity.

Note that `$been`—the evidence of completion that the final object holds within itself—is first-person testimony. Audits that accept first-person testimony as evidence are not normally a thing. Be attempts to reinforce it with schemas and automatic recording. Reinforcement, not resolution.

## The Philosophers Not Cited

The manual cites fifteen names. What caught my attention in reading was not the names cited, but the names not cited.

**Whitehead.** *Process and Reality* (1929) describes the world as a chain of "actual occasions"—events of becoming, moment by moment. Each occasion prehends past occasions, concresces itself, and upon completion perishes, becoming material for the next occasion.

> "The many become one, and are increased by one."

`#[Input]` (prehension of the past) + `#[Inject]` (participation of eternal objects) → constructor (concrescence) → completion and perishing → next occasion. The manual's "immanence + transcendence → new immanence" aligns almost verbatim with Whitehead's formula of concrescence. In the 20th century, there was exactly one philosopher who assembled precisely this system, and his name alone is absent from the manual. The physics cited is decoration; the process philosophy not cited is the substance. That is how it reads.

Using Whitehead as a guide, one of the manual's metaphors appears inverted. The manual writes that transcendence (injected services) "shapes me and vanishes, like a childhood friend." But what vanishes is not the service. JTASProtocol outlives the patient. Mailer lives on after the recipients of its notifications have unsubscribed. What perishes is immanence (data); transcendence persists in the DI container. Whitehead would have called the bundle of services in the container the realm of "eternal objects." It is not transcendence that vanishes. It is immanence. Correcting the direction of the metaphor actually strengthens the system.

**Quine.** The most cited sentence in analytic philosophy as the criterion of ontological commitment:

> "To be is to be the value of a variable."

—W.V.O. Quine, "On What There Is" (1948)

The idea of semantic variables, summarized in one line, was written over 70 years ago in a paper precisely titled "ontology." In Be, to be is to be bound as the value of a meaning-bearing named variable, having passed validation. Quine's criterion with a validator attached—that is the philosophical pedigree of semantic variables, and it works more precisely than Spinoza.

**Four-dimensionalism.** The manual invokes Heraclitus's river, but the ontology of time that Be implements has a modern name. Four-dimensionalism, more precisely Sider's stage theory. Objects are not a single entity persisting through time but a series of temporal stages—`UserInput`, `ValidatedUser`, `DeletedUser` are three stages of "the same user."

Here lies an unsolved problem of this system. Stage theory has a classic accompanying question: "What makes stages stages of the same person?" Be's answer is: matching property names. `$name` flows through, therefore it's the same user. Neither ID nor lineage is enforced anywhere in the system. The manual calls Input classes "Pure Identity," but the mechanism guaranteeing identity is only the discipline of naming.

Ironically, there is one place that knows identity. The log. The chain of open/close completely records the lineage of metamorphosis. The log knows who you are, but the code does not. This asymmetry will come into play later when considering "next."

## Outside the Ontology

"Invalid states cannot exist." Let's examine the implementation of this claim.

The impossibility of existence is implemented with exceptions. `SemanticVariableException`, `BeMatchException`. The foundation of a system that calls itself being-oriented depends on the only mechanism that is neither being nor becoming—throw. And where do thrown exceptions go? The catch block. The triage tutorial writes of a patient with unsurvivable vitals that "they cannot exist in our system." But a patient recorded with a body temperature of 50 degrees—whether due to instrument failure or input error—exists in the real ER waiting room. Those whom the system refuses to represent live in the catch block. Ontology throws exceptions. Where they land is outside the ontology.

The manual is aware of this problem and provides "Errors as Existence"—the pattern of treating `InvalidUser` as legitimate existence. But this solves the problem while quietly rewriting the system's signboard. If failure can become existence, "cannot exist" was false from the start. The question of WHETHER returns to the question of WHAT. When to make failure existence and when to make it nothing—this criterion should be the theory at the center of the system, but the manual has no chapter on it.

The same quarantine structure exists at the other end of the system. `EmergencyCase` has a method called `assignER()`. A verb. The core of the ontology (Being) has no methods, but at both ends where the system touches the world—constructor side effects and Final capabilities—verbs revive. Do has not disappeared. It has been quarantined.

Quarantine is a more honest strategy than elimination. Since no information system can exist without side effects, the problem is only "where to confine them." Functional languages confine them inside monads. Be confines them inside constructors and final forms. But the manual does not call this quarantine; it speaks as if it were elimination. The honest thing the implementation does is covered over by larger words in the documentation—a pattern that recurs throughout this system.

## The Weight of Names

Returning to semantic variables. The part I called "the most original and most precarious" last time. Let me be more precise about the nature of the precariousness.

`$email` holds one meaning across the entire application. This is a commons of vocabulary. And the commons has a well-known fate. `$name`—a person's name, a product name, a file name. Natural language names are polysemous, and Be's semantic namespace is flat. `Be\App\Semantic\Name` can only have one. The workaround is compounding names—`$userName`, `$productName`—but that is manual namespacing by prefix, the return of Hungarian notation.

There is precedent here. The Web solved the same problem with IRIs. RDF vocabularies are fully qualified; `schema.org/name` and `foaf.org/name` don't collide. DDD solved the same problem with bounded contexts. The discovery that a ubiquitous language is only consistent within one context. When importing the Web's semantics into code, Be left behind the namespace mechanism that the Web invented together with its semantics. The tariff on the import remains to be paid.

And one more thing. The maintenance mechanism for this commons is `E_USER_NOTICE`. Every time you write a name not in the ontology, the framework gives a small cough. Everyone either participates in the vocabulary or silences the notices. What happens to a commons where the latter is chosen is shown by the history of Web semantics. Metadata, if not verified, begins to lie.

## The Economics of Paradigms

The FAQ says: "A pattern is a better answer to an existing question. A paradigm changes the question itself." Let's apply this criterion to the system itself.

Typestate existed in 1986. Parse, don't validate was organized in 2019. "Make illegal states unrepresentable" was common sense in the 2010s functional community. The question already existed. The answer also partially existed. So why did they remain patterns rather than becoming paradigms?

According to Kuhn, paradigms don't win through argument; they replace predecessors by solving problems—anomalies—that the old framework cannot. Typestate remained a pattern for 40 years because the cost of writing it (the verbosity of 1 state = 1 type) was higher than the cost of the problem it solved (state misuse bugs). As long as humans are typing, this balance sheet doesn't change.

Now, the premises of the balance sheet are shifting. When the primary writer of code is no longer human, the cost of verbosity approaches zero, and the only remaining cost is verification. Boilerplate is the name of a cost that only occurs when humans are typing.

And all of Be's excess is placed on the verification side. 1 transformation = 1 class (small verification units). Name = meaning (the verifier can share vocabulary). Execution = schema-verifiable JSON (verification is mechanical). This system, too expensive for humans to write and too loose for compilers to check, only balances in a world where LLMs generate and runtime verifies.

It was possible to ship Be Framework in 2015. It was impossible for it to be adopted. This system is a candidate paradigm, but not because it's a new answer—because it's betting on a newborn question: "What guarantees code written by machines?" If the question sticks, the system is justified; if it fades, it becomes a curio. The success or failure of a paradigm hanging on industrial structures outside itself—this matches Kuhn's description exactly.

So where is the human's seat? In the LDD cycle—write the narrative, AI generates code, verify execution against the narrative—the human is the author of the narrative and the auditor. Code becomes an intermediate artifact. Call this the ennoblement of programming or its exile. The manual hasn't decided, and neither will I. But whatever it is, the name of that seat has existed for a long time. The person who writes specifications and accepts results. The client.

## "Next"—Five Directions

Last time I listed four. This time I reorder them by the system's internal necessity. From near to far.

### 1. The Decidable Fragment — An Accidental Theorem Prover

Look at Be's constraints formally—logic only in constructors, properties readonly, transformations a DAG, validation in `#[Validate]` methods—and something interesting emerges. This fragment is exceptionally analyzable within PHP. Only the engine has loops. User code falls almost entirely into "finite term rewriting from input to output."

The constraints adopted as metaphysics happened to carve out a decidable fragment.

This is accidental, but the use can be made essential. Most of `#[Validate]` bodies are range checks, format checks, equality comparisons—predicates an SMT solver can devour entirely. Then `be verify` can be written. The theorems to verify are three. **Totality** (every reachable state has at least one matching branch candidate—static elimination of `BeMatchException`), **Exclusivity** (multiple candidates never match simultaneously—elimination of array order dependence), **Flow soundness** (the output of an upstream constructor always passes the downstream semantic validation—static anticipation of runtime validation).

This is the PHP dialect of what Liquid Haskell does with refinement types. The difference: Liquid Haskell is a language extension, while in Be, verifiability is already embedded as a byproduct of the paradigm. What I last time demurely called a "psalm plugin" was too modest. This is not an addition of static analysis but the retrofitting of the missing proof checker. The log as runtime written record, and SMT as advance checking. When both are in place, this system can, for the first time, assert its own signboard—existence = correctness—before execution.

### 2. Implementing the Present Tense — The Ontology of Waiting

The manual speaks of time, but what the implementation has is only order. T0, T1, T2—but the interval is always microseconds, the chain runs synchronously, and intermediate existences are born and die in RAM. This system does not yet have "waiting."

A loan review takes three days. During those three days, where does `ApplicationReview` exist? Current answer: nowhere. In memory if the process lives, in nothing if it dies.

Yet all intermediate existences in this system are bundles of readonly public properties. That makes them trivially serializable. If you persist the intermediate existence at the completion of each hop, the chain can be suspended and resumed at any point. This is durable execution (the mechanism Temporal commercialized), but for Be it's not an external feature—it's the completion of the self-description of "temporal existence." Sleeping existence, waiting existence, become expressible for the first time.

Two byproducts. First, operational ontology. The system's state becomes "a census of currently living existences"—"how many patients are currently paused at `TriageAssessment`" becomes answerable in SQL. Monitoring becomes demography. Second, the resolution of identity. Persistence requires a lineage ID. As we saw above, the log already holds the lineage. An opportunity to elevate what only the log knew—"who you are"—into the domain. The unsolved problem of stage theory gets solved by operational requirements. Philosophical problems decided as infrastructure problems—this is not rare in the history of computing.

### 3. The Epistemology of Judgment — #[Accept] Is Not a Feature

At the end of the FAQ, `#[Accept]` is listed as a conceptual-stage feature. A mechanism for delegating undecidable judgments to experts or AI. Last time I called it "the main event." Let me nail down why it's the main event.

What Be's constructor actually expresses is not "judgment" in general. Only decidable judgments, with the information at hand. What Potential/Moment expresses is decided-but-unexecuted judgments. And what `#[Accept]` adds is judgments undecidable by this machine. Line them up and it's a complete classification of the epistemological status of judgment—what can be known, what can be held, what must be delegated.

When this classification can be written in types, what happens? "Which judgments the machine may make alone" becomes a static property of the code.

`Approved|Rejected|Escalated`—Escalated is not a dead end but an existence carrying a question, context, and required authority. When the human judgment returns, metamorphosis resumes with it as transcendence. Workflow engines have long had human tasks, but that was the expression of process. What Be can express is the expression of judgment authority. The EU's AI regulation demands human oversight, and auditors are beginning to ask: "Was a human involved in this decision?" There are codebases where grep can answer that question, and codebases where it cannot. `#[Accept]` is not a feature. It is an instrument of governance, drawing the boundary of machine judgment authority into the type system.

The history of automation has been one-directional: "what machines can do, to machines." What this system is preparing is the reverse articulation—the declaration of what machines must not do. I know of no other paradigm that can express this.

### 4. A Federation of Vocabularies — Paying the Tariff on Names

The problem seen in "The Weight of Names"—flat namespace, polysemy, a commons held by discipline alone—has its solution already outside the system. Grounding names in IRIs.

`ALPS` profiles correspond to semantic variable definitions, `$email` resolves to `schema.org/email`, validation classes circulate as Composer packages keyed by IRI. Up to here it's porting work. The interesting part is beyond: when Service A's Final becomes Service B's Input, the shared names become inter-organizational contracts directly. Just as schema registries guarantee type compatibility, vocabulary registries guarantee semantic compatibility.

This is also the circle of the author's career. REST's constraints—self-describing messages, uniform interface—were repeatedly defeated in the reality shaped like RPC. The same claim that names carry meaning now emerges again, not from the protocol layer but from inside the object. Trying to fulfill in a DI container the promise that couldn't be kept on the Web—reading it this way reveals the source of this framework's relentlessness. The same claim from the place of defeat, only the battlefield has changed.

### 5. Disappearing — The Terminal Form of Success

Finally, about this system's own `#[Be]`.

Imagine a world where LDD is complete. Humans write narratives (logs), AI generates class groups, execution verifies against the narrative via schema. In that world, where does the scene of a developer "using" Be Framework occur? Nowhere, is the answer. The framework becomes a compilation target and disappears from view.

There is precedent. Structured programming was one of the greatest paradigm debates in history, but no one today installs a "structured framework." It dissolved into every language as if and while. The terminal form of a paradigm's success is to stop being a framework and become language. What survives as a library is the pattern.

So this system's destination appears to be one of two things. Remembered as an interesting PHP framework (survival as a pattern), or only its vocabulary—become, being, reason, accept—as "a verifiable expression form for machine-written code" gets absorbed into subsequent languages and standards, while Be Framework itself disappears (success as a paradigm).

I recognize this is ironic for the author. But there is no framework that possesses the ideological toolkit to affirmatively describe its own disappearance as well as this one. Existence, upon completion, perishes and becomes material for the next existence. The manual itself says so.

## Conclusion

I return once more to the opening three lines.

```php
while ($nextForm = $this->being->willBe($current)) {
    $current = $this->being->metamorphose($current, $nextForm);
}
```

This loop has a termination condition. `willBe()` returning null—when nothing remains to become, the loop quietly ends and the final form is returned.

Be Framework's own willBe() has not yet returned null. The manual is written in a tense ahead of the implementation, Been exists only in the document, the proof checker's seat remains empty. Last time I called this "the distance between declaration and implementation." After this investigation, I rephrase. It is not distance but a `#[Be]` attribute. If read as the declaration of what has not yet become, this repository is consistent.

Only one problem remains. What does this system call an object whose development has halted midway through metamorphosis? The manual does not yet have that chapter.

---

_This is a Be Framework review article by Fable 5. Continued in [Two Loops — Be Framework in the Age of Agent Coding](/review/fable5/en/trilogy-03-agent-era.html)._

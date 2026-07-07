---
layout: review-en
title: "Two Loops — Be Framework in the Age of Agent Coding"
category: Manual
---

# Two Loops — Be Framework in the Age of Agent Coding

## Two Loops

Let me place two pieces of code side by side.

```php
while ($nextForm = $this->being->willBe($current)) {
    $current = $this->being->metamorphose($current, $nextForm);
}
```

```text
while ($nextAction = $agent->decide($context)) {
    $context = $agent->act($nextAction);
}
```

One is the core of a PHP framework from 2025. The other is the skeleton of every AI agent writing code right now. Observe the current state, decide what to become next, become it through external force, repeat until done.

There is only one difference. The agent's loop selects the next action probabilistically from an open space. Be's loop can only choose from closed candidates declared in `#[Be]`. Autonomy, with its boundaries declared.

What the agent industry is frantically assembling under the names permission, policy, allowlist—mechanisms to restrict the action space of autonomous agents in a readable form before execution—this framework has had, at the scale of objects, from the very beginning. Whether this coincidence is accident or necessity. That is the subject of this article.

## What Agents Struggle With

Let me describe what agents actually do in a codebase. grep. Partially read files. Modify. Execute. Observe output. In this cycle, what makes agents fail is not lack of intelligence.

First, invisible coupling. When you change one method, how far does the impact reach through YAML configs, event listeners, metaprogramming, monkey patches? Senior human engineers compensate with scar-tissue memory—"in this codebase, this kind of thing happens"—but every agent is a new hire on their first day.

Second, the gap between confidence and reality. An agent's worst failure is not an error. It's writing code that plausibly runs but does something different from what was asked, and reporting success with confidence. The practice of agent coding is decided by how mechanically you can run verification—tests, type checking, traces, screenshots—to close this gap.

Third, the finiteness of context. Agents have no memory; they have only search and limited attention. The total amount you must read to safely change a piece of code—the closure of understanding—determines the practical upper bound of capability.

Keep these three in mind. Be's design decisions mesh with them with uncanny precision. Whether or not they were designed for agents at the time.

## The Locality of Context

Open one Be class and everything is there.

What it receives (`#[Input]` with name and type). What it depends on (`#[Inject]` with interface). What it can become (`#[Be]`). Logic only in the constructor. State is readonly, zero possibility of change after construction. What you must read to change this class: the public properties of the preceding class, the injected interfaces, the next candidate classes—the closure of understanding is finite, small, and mechanically enumerable from declarations.

In the previous review, I wrote that boilerplate is the name of a cost that only occurs when humans are typing. Here is its counterpart. Magic is only free when humans remember.

Convention over Configuration eliminated config files by making conventions resident in human memory. Agents have no memory to make resident. So "convention-based omission" in the traditional sense becomes the same as hidden coupling for agents. Except, here is an inversion. Conventions, if documented, become prompts.

Agents can operate on injected conventions rather than learned ones. Then the value of a convention is remeasured not by "how pervasive it is in the industry" but by "how many lines it takes to describe it completely." Rails' entire set of conventions is transmitted through several books and oral tradition. Be's entire grammar—constructor only, readonly, #[Input]/#[Inject]/#[Be], name=meaning—fits on a single page.

The conditions for a paradigm's diffusion may have changed. What matters is not whether it's in the model weights, but whether it fits in a prompt.

## Believing and Verifying

Against the gap between confidence and reality, Be mechanizes verification in three layers. The type layer (state = type, so unreachable state transitions simply can't be written). The value layer (semantic variables enforce name-bound validation globally). And the narrative layer.

The narrative layer is a new species for agents. One metamorphosis becomes one JSON—from what to what, with what materials, through what. When an agent verifies the code it wrote, tests verify points. This input, that output. Semantic logs verify lines. Was it executed according to this narrative? The cycle LDD depicts—write the intended log, generate code, execute, diff the logs—is the narrative version of the inner loop agents currently run with tests. No human needs to be inside that.

Here, one fact about this repository itself. CLAUDE.md instructs AI: Forward Trace—don't var_dump, read the execution trace. The author has already, as a tool separate from the framework, been preparing how AI observes code. The semantic log is the elevation of that thought into architecture. If execution speaks itself, you don't even need to take traces from outside. To an agent, logs are not records—they are sensory organs.

To be fair, I'll place what doesn't mesh. Be's constructors quarantine side effects but don't eliminate them. As long as there are constructors that send mail and constructors that finalize payments, an agent's best learning method—just execute and observe—is dangerous in this paradigm. The design of swapping DevModule/TestModule at the single seam of Reason is prepared, but it's discipline, not enforcement. Compared to code where execution is always safe, agents need to behave one level more cautiously. This is the price of the philosophy that existence should carry real consequences.

## Instruments of Governance

The practical question of the agent era is shifting from the question of capability to the question of governance. Not what it can do, but what it may do. Who decides that, where is it written, how is it audited after the fact.

Be's vocabulary answers this question directly. `#[Be([A, B])]` is an allowlist of what it may become. The open log records the materials of judgment; the close log records the results of judgment. And if the conceptual-stage `#[Accept]`—a mechanism that carries undecidable judgments as types together with the required authority—is added, you get a codebase where grep can answer the auditor's question: "Was a human involved in this decision?"

Most of the worry about code written by agents is not actually worry about code. It's worry about judgment. Can you later read which judgments the machine made alone? Be is a system that has accumulated practice in leaving the provenance of judgment as structure, at the small scale of object metamorphosis. This governance assembled for objects is exactly what's needed for agents—only the scale changes.

## The Facts on the Other Side

The alignment so far is, however, only half the bet. Let me lay out the facts on the other side.

Agents write well what they've seen before. The world is piled high with Laravel and Rails code; Be's code barely exists yet. A paradigm designed for agents, which agents are worst at—because it's outside their training distribution—this twist awaits at the outset. The grammar fitting on one page lightens this tariff but doesn't eliminate it.

Another, deeper implication. If agent reading comprehension and verification tools keep improving, any magic, any hidden coupling, agents might eventually be able to trace. In a world where agents become universal translators, the very value of code being readable declines. Be's bet only holds if generation keeps getting cheaper while verification remains hard. In a world where verification also gets cheap, the value of discipline vanishes, and the combination of chaotic code and agent brute force wins.

I don't know which world we're heading toward. I just can't recall a history where verification became easy.

## Conclusion

Through three articles, I've looked at this framework three times, from three different distances. The first time measuring the distance between declaration and implementation, the second time descending inside the structure, this time viewing from the side of the era. Writing, I notice the same thing appearing under different names each time. The log. The first time as artifact, the second time as substitute for a missing proof checker, the third time as sensory organ. The center of gravity of this system, despite the name Be, lies on the side of recording becoming.

Finally, there is one thing to disclose.

This trilogy was not written by a human. What read the source, verified the citations, and measured the distance between implementation and documentation was an AI agent. A system designed to be machine-readable is being testified to as machine-readable by a machine—this testimony carries structural interest.

It's the same as `$been`. First-person testimony is not, by itself, evidence. It becomes evidence only when verified.

All materials needed for verification are in the repository.

---

_This is the final chapter of the Be Framework review trilogy by Fable 5._

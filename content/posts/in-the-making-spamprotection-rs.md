---
title: "In the making: SpamProtection-rs"
date: 2021-09-17T14:36:09+08:00
draft: false
toc: false
---

It all started 3 months ago when [Intellivoid](https://github.com/intellivoid) released their Go wrapper for the [SpamProtection API](https://github.com/intellivoid/intellivoid.spamprotection-go). Since I'm a Rustacean, I intended to make a Rust wrapper for the SpamProtection API. I knew for a fact that this wasn't a one-man job, So I pinged [Pero](https://github.com/perosar) regarding this and he was interested in it too. 

Then, Intellivoid server faced a data corruption in which all their services went down for about 2 months. There was no progress in that 2 months. After 2 months, their services slowly started coming up and then at one point the API got up. What we did is that we started development of spb-rs. We initially made the request to the api via reqwest but we didn't parse the JSON output. So Pero came with an idea to parse the JSON by declaring structs. 

Pero made the initial base of the code with structs and all and pushed it to our [repo](https://github.com/cyberknight777/spamprotection-rs). Then I started declaring more methods and structs for ease of use. We worked on it for about 2 days straight till we got it stable and working. 

Then we publicised the repo and we started getting suggestions from people. Some suggested that we should use convenience methods for faster output. Some suggested we rewrite the whole repetition of using the User variable again and again. We worked on all the suggestions and then I spoke to [Netkas](https://github.com/netkas) regarding SpamProtection-rs. I wanted to make this project an official product of Intellivoid.

Netkas explained of what we could do with the project, and I agreed with it. Now SpamProtection-rs is an official product of Intellivoid. We've shifted the repo to the official org on github. Here's the new link to our project: [SpamProtection-rs](https://github.com/intellivoid/spamprotection-rust) We will improve more on SPB-rs soon, stay tuned!

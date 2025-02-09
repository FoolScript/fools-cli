<p align="center">                    
<a href="https://img.shields.io/badge/License-MIT-green"><img src="https://img.shields.io/badge/License-MIT-green" alt="MIT License"></a>
<a href="https://pub.dev/packages/fools"><img src="https://img.shields.io/pub/v/fools?label=pub&color=orange" alt="pub version"></a>      
<a href="https://twitter.com/code_ontherocks">
    <img src="https://img.shields.io/twitter/follow/code_ontherocks?style=social">
  </a>
</p>


<p align="center">
 <a href="https://foolscript.com">Documentation</a> •
  <a href="https://joemuller.com">Developer Blog</a> •
  <a href="https://github.com/FoolScript/fools-cli">GitHub Repo</a> •
  <a href="https://pub.dev/packages/fools/install">Pub.dev</a>
</p>

---

> The fool doth think he is wise, but the wise man knows himself to be a fool. - William Shakespeare

This CLI populates the `.github/prompts` folder with helpful prompts because we are all _fools_ and forget the syntax of the tools we use 🃏

# Installation

```bash
dart pub global activate fools
```

# Setup

```bash
fools start
```

# Usage

In the Copilot Chat panel of VS Code, you can reference the FoolScript prompts by typing `#` followed by the prompt name. For example:

```txt
#fools-cli.prompt.md 
```

> [!TIP]
> VS Code will suggest prompts as soon as you start typing and will use smart matching to find the prompt you are looking for. Instead of typing "fools-cli", you could type "fc" or "cli".

# Development

```bash
dart run bin/fools.dart start
```
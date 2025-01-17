> The fool doth think he is wise, but the wise man knows himself to be a fool.
> - William Shakespeare

This CLI helps you populate the `.vscode` folder with helpful `tasks.json` and `snippets.code-snippets` files because we are all _fools_ and forget the syntax of the tools we use 🃏

# Apply a specific configuration

```
fools config -t dart-cli
fools config -t readme
fools config -t hugo
```
# VS Code Tasks
[VS Code tasks](https://code.visualstudio.com/Docs/editor/tasks) are reusable tasks that can be run from the command palette or from a keyboard shortcut. They are defined in a `tasks.json` file in the `.vscode` folder of your workspace.

> [!IMPORTANT]
> The fools CLI will create a `tasks.json` file in the `.vscode` folder of your workspace if you do not have one.

# VS Code Snippets

[VS Code snippets](https://code.visualstudio.com/docs/editor/userdefinedsnippets) are templates that make it easier to enter repeating code patterns, such as loops or conditional-statements. You can create workspace specific snippets by creating a file that ends in `.code-snippets` in the `.vscode` folder of your workspace.

> [!IMPORTANT]
> The fools CLI will create a `snippets.code-snippets` file in the `.vscode` folder of your workspace if you do not have one.

# Development

```bash
dart run bin/fools.dart config -t hugo
```
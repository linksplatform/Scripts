# Make Variables Constexpr Script

This script converts `auto` variable declarations for `$break`, `$continue`, and `any` variables to `static constexpr` declarations in C++ code.

## Purpose

The script addresses issue #23 by automatically converting the following patterns:

- `auto $break = Constants.Break;` → `static constexpr auto $break = Constants.Break;`
- `auto $continue = Constants.Continue;` → `static constexpr auto $continue = Constants.Continue;`
- `auto any = Constants.Any;` → `static constexpr auto any = Constants.Any;`
- `auto $break {Constants.Break};` → `static constexpr auto $break {Constants.Break};`
- `auto $continue {Constants.Continue};` → `static constexpr auto $continue {Constants.Continue};`
- `auto any {Constants.Any};` → `static constexpr auto any {Constants.Any};`

## Usage

```bash
# Process current directory
./make_constexpr.sh

# Process specific directory
./make_constexpr.sh /path/to/cpp/project

# Show help
./make_constexpr.sh --help
```

## What it does

1. Searches for C++ files (.h, .hpp, .cpp, .cc) in the specified directory
2. Applies regex transformations to convert auto declarations to constexpr
3. Only modifies lines that exactly match the expected patterns
4. Preserves indentation and formatting
5. Reports which files were modified

## Safety

- Only converts specific patterns that match Constants.Break, Constants.Continue, and Constants.Any
- Does not modify other auto variable declarations
- Preserves original file formatting and indentation
- Shows clear output indicating which files were changed

## Example

Before:
```cpp
void someMethod() {
    auto $break = Constants.Break;
    auto $continue = Constants.Continue;
    auto any = Constants.Any;
}
```

After:
```cpp
void someMethod() {
    static constexpr auto $break = Constants.Break;
    static constexpr auto $continue = Constants.Continue;
    static constexpr auto any = Constants.Any;
}
```
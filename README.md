# @tsonic/dotnet-pure

TypeScript type definitions for .NET 10 BCL (Base Class Library) with **CLR naming conventions**.

> **Note:** This package uses PascalCase member names (e.g., `GetEnumerator`, `Count`). For camelCase TypeScript-style naming, use `@tsonic/dotnet` instead.

## Features

- **Complete .NET 10 BCL coverage** - 130 namespaces, 4,296 types, 50,675 members
- **CLR naming conventions** - PascalCase members matching .NET exactly
- **Friendly generic aliases** - Use `List<T>` instead of `List_1<T>`
- **Primitive aliases** - `int`, `long`, `decimal`, etc. via `@tsonic/core`
- **Full type safety** - Zero TypeScript errors

## Installation

```bash
npm install @tsonic/dotnet-pure @tsonic/core
```

## Usage

```typescript
import type { List } from "@tsonic/dotnet-pure/System.Collections.Generic";
import type { int } from "@tsonic/core/types.js";

const list: List<int> = null!;
list.Add(42 as int);           // PascalCase: Add, not add
const count = list.Count;       // PascalCase: Count, not count
const enumerator = list.GetEnumerator();  // PascalCase: GetEnumerator
```

## Naming Comparison

| Feature | @tsonic/dotnet | @tsonic/dotnet-pure |
|---------|----------------|---------------------|
| Methods | `getEnumerator()` | `GetEnumerator()` |
| Properties | `count` | `Count` |
| Style | TypeScript/JS convention | CLR/C# convention |

## When to Use

- **@tsonic/dotnet** - For TypeScript projects preferring JS naming conventions
- **@tsonic/dotnet-pure** - For projects requiring exact CLR name matching (e.g., reflection, interop)

## Development

### Regenerating Types

```bash
./__build/scripts/generate.sh
```

**Prerequisites:**
- .NET 10 SDK installed
- `tsbindgen` repository cloned at `../tsbindgen`

**Environment variables:**
- `DOTNET_VERSION` - .NET runtime version (default: `10.0.0`)
- `DOTNET_HOME` - .NET installation directory (default: `$HOME/.dotnet`)

## License

MIT

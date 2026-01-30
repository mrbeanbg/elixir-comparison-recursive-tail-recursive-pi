# Pi Computation Methods in Elixir

Implementation of three classical numerical methods for computing the value of π (pi) in Elixir.

## Overview

This project implements three historical formulas for calculating π:

| Method | Formula Type |
|--------|--------------|
| Leibniz | Alternating series |
| Wallis | Infinite product |
| Viète | Nested square roots |

Each method is implemented in two versions:
- **Recursive**: Classical recursion (stack grows linearly)
- **Iterative**: Tail recursion with accumulator (constant stack due to TCO)

## Formulas

### Leibniz Formula
```
π/4 = 1 - 1/3 + 1/5 - 1/7 + 1/9 - ...
```

### Wallis Formula
```
π/2 = (2/1)·(2/3)·(4/3)·(4/5)·(6/5)·(6/7)·...
```

### Viète Formula
```
2/π = (√2/2) · (√(2+√2)/2) · (√(2+√(2+√2))/2) · ...
```

## Installation

1. Make sure you have Elixir installed
2. Clone the repository:
```bash
git clone https://github.com/yourusername/pi-computation-methods.git
cd pi-computation-methods
```

3. Compile the module:
```bash
elixirc pi_computation_methods.ex
```

## Usage

### Interactive Shell (iex)

```elixir
iex> c("pi_computation_methods.ex")
[PiComputationMethods]
```

### Running Benchmark

```elixir
iex> PiComputationMethods.benchmark()
```

This will run all methods with n = 10, 30, 100, 1000, 10000, 100000 and display:
- Computed π value
- Error (difference from `:math.pi()`)
- Execution time (ms)
- Approximate memory usage (KB)

## Benchmark Results

### Convergence Speed

| Method | n=100 error | n=100000 error |
|--------|-------------|----------------|
| Leibniz | ~0.01 | ~1e-5 |
| Wallis | ~0.0078 | ~7.8e-6 |
| Viète | **1e-15** | **1e-15** |

Viète reaches machine precision at just n=30!

### Performance (n=100000)

| Method | Recursive | Iterative | Speedup |
|--------|-----------|-----------|---------|
| Leibniz | 5.4 ms | 0.5 ms | ~11x |
| Wallis | 6.7 ms | 1.0 ms | ~7x |
| Viète | 85,758 ms | 1.4 ms | ~63,000x |

### Memory Usage (n=100000)

| Type | Memory |
|------|--------|
| Recursive | 4,000 to 6,500 KB (grows with n) |
| Iterative | ~12 to 20 KB (constant) |

## Project Structure

```
.
├── README.md
├── pi_computation_methods.ex    # Main module with all implementations
└── docs/
    └── coursework.docx          # Full documentation (Bulgarian)
```

## Key Findings

1. **Viète is the most efficient** for accuracy, reaching machine precision with only ~30 iterations
2. **Iterative (tail recursive) versions** are significantly faster and use constant memory
3. **Erlang VM's Tail Call Optimization** makes tail recursion as efficient as loops
4. **For practical use**, the iterative Viète method is recommended

## API Reference

### Leibniz Method
```elixir
leibniz_recursive_pi(n)              # Recursive version
leibniz_iterative_tail_recursive_pi(n)  # Iterative version
```

### Wallis Method
```elixir
wallis_recursive_pi(n)               # Recursive version
wallis_iterative_tail_recursive_pi(n)   # Iterative version
```

### Viète Method
```elixir
viete_recursive_pi(n)                # Recursive version
viete_iterative_tail_recursive_pi(n)    # Iterative version
```

### Benchmark
```elixir
benchmark()                          # Run all methods and compare
```

## License

MIT License


## References

- [Pi (Wikipedia)](https://en.wikipedia.org/wiki/Pi)
- [Leibniz formula for π](https://en.wikipedia.org/wiki/Leibniz_formula_for_%CF%80)
- [Wallis product](https://en.wikipedia.org/wiki/Wallis_product)
- [Viète's formula](https://en.wikipedia.org/wiki/Vi%C3%A8te%27s_formula)

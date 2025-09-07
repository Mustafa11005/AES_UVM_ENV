# AES_UVM_ENV

A UVM-based verification environment for AES (Advanced Encryption Standard) modules implemented in SystemVerilog/Verilog.

---

## Overview

**AES_UVM_ENV** is a modular, coverage-driven verification environment built using the Universal Verification Methodology (UVM). It is designed to verify AES encryption/decryption RTL blocks with constrained-random and directed stimulus, functional coverage, and assertions.

This repository contains UVM components (agents, sequences, drivers, monitors), RTL samples, and helper scripts for generating test vectors.

---

## Repository structure

```
AES_UVM_ENV/
├── UVM/                # UVM environment (env, agents, components, sequences, tests)
│   ├── env/
│   ├── agents/
│   ├── drivers/
│   ├── monitors/
│   ├── sequences/
│   ├── scoreboards/
│   └── tests/
├── rtl/                # AES RTL (encryption/decryption modules)
├── tb/                 # Testbench wrappers (top-level tb files)
├── Python_gen/         # Scripts to generate test vectors (plaintext, key, expected ciphertext)
├── docs/               # Documentation, verification plan, coverage goals (optional)
├── scripts/            # Helper scripts for build/run/coverage collection
├── sim_reports/        # Simulation logs, coverage databases & HTML reports
└── README.md
```

> If your directory layout is different, update the structure above to match the repo.

---

## Features

- UVM-based, modular verification components
- Functional coverage (covergroups, coverpoints, cross coverage)
- Assertion support (SVA) and optional assertion coverage
- Python test-vector generation scripts for randomized and directed vectors
- Example tests and sequences to exercise AES operations

---

## Quick start

### Prerequisites

- SystemVerilog simulator (e.g. Questa/ModelSim, VCS, Riviera-PRO)
- UVM library (UVM 1.1 or later)
- Python 3.x (for test-vector generation and utility scripts)
- GNU Make (optional, for convenience scripts)

### Generate test vectors (optional)

If `Python_gen` contains generator scripts, run them before simulation:

```bash
cd Python_gen
python generate_vectors.py --count 1000 --out ../sim_reports/vectors
```

Adjust flags to your script's options.

### Compile & simulate (examples)

**Questa/ModelSim**

```bash
# compile
vlog -sv rtl/*.sv tb/*.sv UVM/*.sv
# run (example)
vsim -c work.tb_top -do "run -all; coverage save -onexit sim_reports/coverage.ucdb; exit"
```

**VCS**

```bash
# compile
vcs -full64 -sverilog +acc +vcs+lic+wait rtl/*.sv UVM/*.sv tb/*.sv -l compile.log
# run
./simv +UVM_TESTNAME=basic_test +UVM_VERBOSITY=UVM_LOW -l sim.log
# collect coverage (vcs-specific)
urg -report -dir sim_reports/coverage
```

> Replace `tb_top`, `basic_test`, and file lists with the actual top-level testbench module/test names in this repo.

---

## Running tests & examples

- Look into `UVM/tests/` for provided example tests. Each test typically sets up the environment, sequences, and any directed vectors.
- Run tests with the simulator by passing `+UVM_TESTNAME=<test_name>` or environment variable expected by your UVM build.

Example:

```bash
./simv +UVM_TESTNAME=seq_random_key_test +UVM_VERBOSITY=UVM_HIGH
```

---

## Coverage

This environment collects **functional coverage** (covergroups, coverpoints, crosses) and may collect **code coverage** (if your tool supports it).

### Tips

- Define coverpoints for important signals: `key`, `round`, `state`, `mode`, special patterns, error conditions, etc.
- Use **cross coverage** for interactions you care about (e.g., `mode x key_size`, or `plaintext_pattern x round_count`).
- Perform hole analysis regularly and prioritize un-hit bins by risk and specification importance.

Example: merging/saving coverage (tool-specific):

- Questa: `coverage save -onexit sim_reports/coverage.ucdb` then `vcover report -details coverage.ucdb`
- VCS: use the tool's coverage reporting utilities (consult vendor docs)

---

## Assertions

- Add SVA properties where protocol or algorithmic invariants must hold (for example: input sizes, handshakes, or state invariants).
- Use `cover property` to track temporal sequences (e.g., `request -> ack within N cycles`) when those sequences are important to verify.
- Monitor assertion failures in logs and treat them as early indicators of RTL/testbench mismatches.

---

## How to extend

- **Add new sequences/tests** in `UVM/sequences/` to target edge cases.
- **Add covergroups** in the monitor or scoreboard to increase functional coverage granularity.
- **Add assertions** in RTL or as SVA modules in `tb/assertions/` for protocol checks.
- **Integrate CI**: add a GitHub Actions workflow that runs smoke simulations or linting to catch regressions.

---

## Contributing

Contributions are welcome. Typical PRs include:

- New tests or sequences
- Additional RTL/testbench examples
- Improved coverage and coverage reports
- CI configuration for smoke/regression runs

When opening a PR, include a brief description of changes and any simulation steps to reproduce results locally.

---

## Helpful commands & tips

- Restart ADB (if using hardware for co-simulation or embedded testing): `adb kill-server && adb start-server` *(only relevant if integrating hardware runs)*
- Use `+UVM_VERBOSITY=UVM_LOW|UVM_MEDIUM|UVM_HIGH` to control log verbosity
- Keep test vectors and golden outputs in `sim_reports/` for reproducibility

---

## License

Add a `LICENSE` file to this repo. If you are not sure, MIT or Apache-2.0 are common open-source choices. Example: `MIT`.

---

## Contact

Maintainer: [Mustafa11005](https://github.com/Mustafa11005)

For questions or collaboration, open an Issue or reach out via GitHub.

---

*Happy verifying!*

```markdown
# MANDELBROT Development Patterns

> Auto-generated skill from repository analysis

## Overview

This skill teaches you how to contribute to the MANDELBROT Python codebase, which focuses on terminal entity development and modular system integration. You'll learn the project's coding conventions, commit patterns, and step-by-step workflows for adding new features, planning, integrating entities, and testing. The repository emphasizes documentation-driven development, modular entity structure, and robust testing practices.

## Coding Conventions

- **File Naming:**  
  Use `snake_case` for all Python files and scripts.  
  *Example:*  
  ```
  mandelbrot_core.py
  browser_selector.sh
  session_manager.sh
  ```

- **Import Style:**  
  Use **relative imports** within Python modules.  
  *Example:*  
  ```python
  from .utils import render_fractal
  ```

- **Export Style:**  
  Use **named exports** (explicit function/class names in `__all__` or direct imports).  
  *Example:*  
  ```python
  __all__ = ['MandelbrotRenderer', 'generate_fractal']
  ```

- **Commit Messages:**  
  Follow [Conventional Commits](https://www.conventionalcommits.org/) with these prefixes: `feat`, `fix`, `docs`, `test`, `chore`.  
  *Example:*  
  ```
  feat: add zoom support to mandelbrot renderer
  fix: correct off-by-one error in iteration count
  docs: update README with usage instructions
  ```

## Workflows

### Entity Feature Development Workflow
**Trigger:** When you want to add a new terminal entity (e.g., browser, tool, or service)  
**Command:** `/new-entity`

1. **Design/Spec:**  
   Create a design/spec file in `docs/superpowers/specs/` or `docs/plans/`.
2. **Implementation Plan:**  
   Write an implementation plan in `docs/superpowers/plans/` or `docs/plans/`.
3. **Directory Structure:**  
   Create the entity's directory under `terminals/entities/<entity-name>/` and/or `terminals/<entity-name>/`.
4. **Core Modules:**  
   Add core code modules (e.g., `browser_selector.sh`, `session_manager.sh`, `spirit.sh`, `entity_wrapper.sh`) in the entity directory.
5. **Configuration:**  
   Add configuration files under `terminals/<entity-name>/config/`.
6. **Seed Entities:**  
   Add minimal/seed entities under `terminals/entities/<entity-name>-simple/` or similar.
7. **Documentation:**  
   Add `README.md` and `INSTALL.md` in the entity directory.
8. **Integration:**  
   Integrate the entity into `master_ui.sh` or other launcher scripts.
9. **Testing:**  
   Add test suite scripts (e.g., `test_<entity>.sh`).
10. **Completion:**  
    Mark implementation complete with a `STATUS.md` file and update the spec with completion status.

*Example Directory Structure:*
```
terminals/
  my_entity/
    browser_selector.sh
    session_manager.sh
    config/
    README.md
    INSTALL.md
    test_my_entity.sh
    STATUS.md
```

---

### Documentation-Driven Planning Workflow
**Trigger:** When you want to propose, plan, or design a new feature or system before implementation  
**Command:** `/new-plan`

1. **Design/Spec Document:**  
   Create or update a design/spec in `docs/superpowers/specs/` or `docs/plans/`.
2. **Implementation Plan:**  
   Create or update an implementation plan in `docs/superpowers/plans/` or `docs/plans/`.
3. **Reference in Commits:**  
   Reference these documents in subsequent implementation commits.

*Example Commit Message:*
```
docs: add spec for interactive zoom feature
```

---

### Entity Integration into Master UI Workflow
**Trigger:** When you want to make a new entity/tool available from the main user interface  
**Command:** `/integrate-entity-ui`

1. **Update Launcher:**  
   Edit `tools/master_ui.sh` to add a new menu option for the entity/tool.
2. **Error Handling:**  
   Add error handling or checks for the new entity's presence.
3. **Documentation:**  
   Document the integration in the entity's `README.md` or `INSTALL.md`.

*Example Snippet in `master_ui.sh`:*
```bash
echo "4) Launch My Entity"
# ...
if [[ "$choice" == "4" ]]; then
  ./terminals/my_entity/spirit.sh
fi
```

---

### Test Suite Addition for Entity Workflow
**Trigger:** When you want to ensure a new entity/tool is tested and validated  
**Command:** `/add-entity-test`

1. **Test Script:**  
   Create a test script (e.g., `test_<entity>.sh`) in the entity's directory.
2. **Coverage:**  
   Include tests for core logic, flags, session management, and help output.
3. **Reference:**  
   Reference the test suite in the entity's `README.md` or `STATUS.md`.

*Example Test Script:*
```bash
#!/bin/bash
set -euo pipefail

./spirit.sh --help | grep "Usage"
./spirit.sh --session test | grep "Session started"
```

---

## Testing Patterns

- **Framework:**  
  Not explicitly specified; test scripts are typically shell scripts (`*.sh`) placed in the entity's directory.

- **File Pattern:**  
  Test files follow the pattern `test_*.sh` or `*.test.*` for Python.

- **Test Coverage:**  
  Tests cover logic, flags, session management, and help output.

*Example Test File:*
```
terminals/my_entity/test_my_entity.sh
```

## Commands

| Command              | Purpose                                                        |
|----------------------|----------------------------------------------------------------|
| /new-entity          | Start a new terminal entity feature development workflow        |
| /new-plan            | Begin documentation-driven planning for a new feature/system    |
| /integrate-entity-ui | Integrate a new entity/tool into the main system UI            |
| /add-entity-test     | Add a test suite for a new or updated entity                   |
```

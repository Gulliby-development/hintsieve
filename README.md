<p align="center"><img src="docs/logo.svg" width="96" alt="" /></p>

# hintsieve

hintsieve is an offline, deterministic command-line toolkit for Wordle-style feedback. It scores guesses against answers, filters a word list by clues, measures how guesses divide the remaining candidates, replays a strategy, and checks a game transcript. It is intended for word-game developers and people validating answer lists. It uses no external dependencies.

[![CI](https://github.com/Gulliby-development/hintsieve/actions/workflows/ci.yml/badge.svg)](https://github.com/Gulliby-development/hintsieve/actions/workflows/ci.yml) [![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

## Install and build

Install the Swift 6.2 toolchain for your operating system from [swift.org/install](https://www.swift.org/install/), then confirm that `swift --version` reports Swift 6.2 or newer. The package is cross-platform and uses Swift Package Manager; on macOS it needs macOS 15 or newer.

```sh
git clone https://github.com/Gulliby-development/hintsieve.git
cd hintsieve
swift build
```

The executable is available through SwiftPM as `swift run hintsieve` on Windows, macOS, and Linux. To run a built executable directly, use `.build/debug/hintsieve` on macOS/Linux or `.build/debug/hintsieve.exe` on Windows.

## Quick start

```sh
swift run hintsieve score speed abide
```

The block below is hintsieve's output. On a first run, SwiftPM may also print build progress before launching the command; that build output is not produced by hintsieve.

Output:

```text
bbyby
```

The five positions are black, black, yellow, black, yellow. A pattern uses `g` for a correct letter in the correct position, `y` for a letter in the answer at another position, and `b` for an absent or already-consumed letter.

## Commands

The synopsis is:

```text
usage: hintsieve COMMAND [ARGS]
  score GUESS ANSWER
  filter WORDS [CLUE...]
  rank WORDS [--top N] [CLUE...]
  split WORDS GUESS [CLUE...]
  solve WORDS ANSWER [--first WORD] [--hard]
  check WORDS LOG [--hard]
```

Run `swift run hintsieve help` (also `-h` or `--help`) to print it. With no arguments, hintsieve writes usage to stderr and exits 2. An unrecognized command is an error.

A word is 2–8 lowercase ASCII letters. Guesses and answers for `score` must have the same length. For example:

```sh
swift run hintsieve score crane slate
```

A word-list file has one word per line, all the same length and without duplicates. Here is a small complete list used in the following examples:

```text
crane
slate
trace
crate
grace
brace
stone
```

Save those lines as `words.txt`. A clue is `WORD:PATTERN`: the guess followed by the feedback it received. Clue guesses need not themselves occur in the list. For example, filter candidates using the clue `crane:yggbg`:

```sh
swift run hintsieve filter words.txt crane:yggbg
```

This retains words, in their original file order, whose score against `crane` is `yggbg`; the command prints the candidate words and then `N of M`.

Rank possible guesses by how effectively they separate the current candidates:

```sh
swift run hintsieve rank words.txt --top 3 crane:yggbg
```

Each list word can be a guess. Candidates are grouped by the feedback each guess would produce. A row reports the largest group (`worst`), number of groups (`parts`), and sum of squared group sizes (`squares`). Ordering is ascending by worst, then squares; ties prefer candidate words, then alphabetical order. The output begins with the candidate count. `--top N` accepts 1–9999 and defaults to 5.

Inspect the feedback partition for one guess:

```sh
swift run hintsieve split words.txt crane
```

Patterns are printed in ascending string order; words within each pattern remain in list order. The summary gives the number of patterns and the largest group. With no candidates, split prints `0 patterns, worst 0`.

Replay the strategy against an answer that is in the list:

```sh
swift run hintsieve solve words.txt stone
swift run hintsieve solve words.txt stone --first crane --hard
```

The first turn uses the best-ranked word unless `--first` supplies another word. Later turns use the best-ranked word. With `--hard`, each later guess is selected from the current candidates. The command prints each turn's guess, feedback, and remaining candidate count, and stops on a solved pattern or after ten turns.

Check a transcript by saving one clue per line in `game.log`, for example:

```text
slate:gbbyg
stone:ggggg
```

Then run:

```sh
swift run hintsieve check words.txt game.log
swift run hintsieve check words.txt game.log --hard
```

The output labels transcript lines starting at 1 and reports the remaining candidates and status. A line with no candidates is `impossible`; otherwise hard mode marks a guess `hard` when it violates an earlier clue. Impossible takes precedence. An empty log contains no failing entries and exits 0. The log must be a file: `check` does not accept `-` for its LOG argument.

## Example session

Save the seven words of the list above as `words.txt` and the two clues as `game.log` (`slate:gbbyg`, then `stone:ggggg`); every line below is real output (`stderr:` lines go to standard error, `exit:` shows a non-zero exit status):

```text
$ swift run hintsieve score speed abide
bbyby
$ swift run hintsieve score crane slate
bbgbg
$ swift run hintsieve filter words.txt crane:yggbg
trace
grace
brace
3 of 7
$ swift run hintsieve rank words.txt --top 3 crane:yggbg
candidates: 3
1 brace worst=2 parts=2 squares=5 candidate=yes
2 grace worst=2 parts=2 squares=5 candidate=yes
3 trace worst=2 parts=2 squares=5 candidate=yes
$ swift run hintsieve split words.txt crane
bbbgg 1: stone
bbgbg 1: slate
gggbg 1: crate
ggggg 1: crane
yggbg 3: trace grace brace
5 patterns, worst 3
$ swift run hintsieve solve words.txt stone
1 crate bbbyg 1
2 stone ggggg 1
solved in 2
$ swift run hintsieve solve words.txt brace --first crane --hard
1 crane yggbg 3
2 brace ggggg 1
solved in 2
$ swift run hintsieve check words.txt game.log
1 slate gbbyg 1 ok
2 stone ggggg 1 ok
$ swift run hintsieve check words.txt game.log --hard
1 slate gbbyg 1 ok
2 stone ggggg 1 ok
$ swift run hintsieve filter words.txt crane:bbbbb stone:bbbbb
0 of 7
exit: 1
```

## Input and output rules

- Text files are strict UTF-8. One leading U+FEFF byte-order mark is ignored.
- Lines may end in LF or CR LF. Empty lines and lines beginning with `#` are skipped in word lists; errors identify the physical line number. A second BOM is not stripped and therefore makes the first word invalid.
- All words in a list must be unique and have equal length. Clues are checked against that length.
- Repeated-letter scoring first marks every matching-position letter green and consumes it. It then visits remaining guess letters from left to right, marking a letter yellow only while an unused copy remains in the answer; all other positions are black. Thus `speed` against `abide` is `bbyby`, while `abide` against `speed` is `bbbyy`.
- Options may appear among arguments. Value options accept either `--name=value` or `--name value`. A single `-` means standard input only where a WORDS file is accepted; it is not valid for a check log.
- Output is UTF-8 bytes with LF line endings. Errors go to stderr with the `hintsieve: ` prefix and produce no stdout.

Exit status is 0 for success, 1 for a negative result, and 2 for usage or input errors. A filter with no candidates exits 1; rank with no candidates reports an error and exits 1; solve exits 1 if it reaches ten turns without solving; check exits 1 if any line is impossible or violates hard mode.

## Development

The package treats every compiler warning as an error and has no package dependencies. Run the project checks from the repository root:

```sh
swift format lint --strict --recursive .
swift build
swift test
```

## License

hintsieve is distributed under the MIT License. See [LICENSE](LICENSE).

---

Built with BAKED

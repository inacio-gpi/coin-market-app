#!/bin/sh

# run (win)
#   ./run_coverage.sh
#
# or (linux)
#   sh ./run_coverage.sh
#
# or (linux super user)
#   sudo sh run_coverage.sh
clear

echo "Flutter Run Coverage (by Guilherme Pereira - github.com/inacio-gpi)"
echo "Looking for projects..."

# Generate `coverage/lcov.info` file
flutter test --coverage
# Generate HTML report
# Note: on macOS you need to have lcov installed on your system (`brew install lcov`) to use this:
genhtml coverage/lcov.info -o coverage/html

# Open the report
open coverage/html/index.html


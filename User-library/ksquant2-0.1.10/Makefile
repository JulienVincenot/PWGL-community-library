all:
	ghc -fglasgow-exts --make Main.hs -o main

.PHONY: test
test:
	ghc -fglasgow-exts -fhpc --make Test.hs -o test
	./test 2>/dev/null >test.log
	cat test.log
	tail -n 1 <test.log | grep 'tests passed'
	rm -f test.log
	hpc markup --destdir=test-coverage test 2>/dev/null >/dev/null
	hpc report test

.PHONY: itest
itest:
	ghc -fglasgow-exts --make Test.hs -o test
	./test

.PHONY: shell-tests
shell-tests: all
	clisp -norc lisp/test-runner.lisp

runmain:
	rm -f *.o *.hi
	ghc -fglasgow-exts -fhpc --make Main.hs -o main
	./main <examples/sample-input.lisp
	hpc markup --destdir=main-coverage main 2>/dev/null >/dev/null
	hpc report main

clean:
	git clean -f -x -d 

.PHONY: check
check:
	! grep 'error ""' *.hs
	rm -f main Main *.o *.hi
	ghc -fglasgow-exts -Wall -Werror -fno-warn-missing-signatures \
		-fno-warn-name-shadowing -fno-warn-unrecognised-pragmas \
		--make Main.hs -o main
	rm -f test *.o *.hi
	ghc -fglasgow-exts -Wall -Werror -fno-warn-missing-signatures \
		-fno-warn-name-shadowing -fno-warn-orphans -fno-warn-unrecognised-pragmas \
		--make Test.hs -o test
	hlint .

# ----------------------------------------------------------------

configure: 
	runghc Setup.hs configure --user

doc: configure
	runghc Setup.hs haddock --executables

build: configure
	runghc Setup.hs build

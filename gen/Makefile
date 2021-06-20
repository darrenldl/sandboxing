SRCFILES = src/*.ml

OCAMLFORMAT = ocamlformat \
	--inplace \
	$(SRCFILES)

.PHONY: all
all :
	dune build @all

.PHONY: run
run: all
	rm -f ../scripts/*.sh
	rm -f ../scripts/*.runner
	rm -f ../runners/*.runner
	rm -f ../seccomp-bpfs/*.c
	rm -f ../seccomp-bpfs/*.exe
	rm -f ../seccomp-bpfs/*.bpf
	rm -r ../aa-profiles/home.sandboxing.*
	dune exec gen

.PHONY: format
format :
	$(OCAMLFORMAT)

.PHONY: cinaps
cinaps :
	cinaps -i $(SRCFILES)
	$(OCAMLFORMAT)

.PHONY : clean
clean:
	dune clean

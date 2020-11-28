SRCFILES = src/*.ml

OCAMLFORMAT = ocamlformat \
	--inplace \
	$(SRCFILES)

OCPINDENT = ocp-indent \
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
	$(OCPINDENT)

.PHONY: cinaps
cinaps :
	cinaps -i $(SRCFILES)
	$(OCAMLFORMAT)
	$(OCPINDENT)

.PHONY : clean
clean:
	dune clean

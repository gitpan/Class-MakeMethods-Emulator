use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'		=> 'Class::MakeMethods::Emulator',
    'VERSION_FROM'	=> 'Emulator.pm', 
    'PREREQ_PM'		=> {
      Class::MakeMethods => 1.003,
      Class::MakeMethods::Template => 1.003,
    }, 
    ($] >= 5.005 ? (
      ABSTRACT_FROM => 'Emulator.pm', 
      AUTHOR     => 'Matthew Simon Cavalletto <simonm@cavalletto.org>',
    ) : ()),
);
sub MY::postamble { q{

docs : README CHANGES TODO

README: Emulator.pm
	pod2text Emulator.pm > README

CHANGES: Emulator/Changes.pod
	pod2text Emulator/Changes.pod > CHANGES

TODO: Emulator/ToDo.pod
	pod2text Emulator/ToDo.pod > TODO

cleanmanifest:
	make realclean; rm MANIFEST ; perl Makefile.PL; touch MANIFEST; make manifest

}; }

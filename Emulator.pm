package Class::MakeMethods::Emulator;

$VERSION = 1.003;

@EXPORT_OK = qw( namespace_capture namespace_release );
sub import { require Exporter and goto &Exporter::import } # lazy Exporter

########################################################################
### NAMESPACE MUNGING: _namespace_capture(), _namespace_release()
########################################################################

sub namespace_capture {
  my $source_package = shift;
  my $target_package = shift;
  
  my $source_file = "$source_package.pm";
  $source_file =~ s{::}{/}g;
  
  my $target_file = "$target_package.pm";
  $target_file =~ s{::}{/}g;
  
  my $temp_package = $source_package . '::Target::' . $target_package;
  my $temp_file = "$temp_package.pm";
  $temp_file =~ s{::}{/}g;
  
  no strict;
  unless ( ${$temp_package . "::TargetCaptured"} ++ ) {
    *{$temp_package . "::"} = *{$target_package . "::"};
    $::INC{$temp_file} = $::INC{$target_file};
  }
  *{$target_package . "::"} = *{$source_package . "::"};
  $::INC{$target_file} = $::INC{$source_file}
}

sub namespace_release {
  my $source_package = shift;
  my $target_package = shift;
  
  my $target_file = "$target_package.pm";
  $target_file =~ s{::}{/}g;
  
  my $temp_package = $source_package . '::Target::' . $target_package;
  my $temp_file = "$temp_package.pm";
  $temp_file =~ s{::}{/}g;
  
  no strict;
  unless ( ${"${temp_package}::TargetCaptured"} ) {
    Carp::croak("Can't _namespace_release: -take_namespace not called yet.");
  }
  *{$target_package . "::"} = *{$temp_package. "::"};
  $::INC{$target_file} = $::INC{$temp_file};
}

########################################################################

1;

__END__



=head1 NAME

Class::MakeMethods::Emulator - Demonstrate class-generator equivalency


=head1 SYNOPSIS

  # Equivalent to use Class::Singleton;
  use Class::MakeMethods::Emulator::Singleton; 
  
  # Equivalent to use Class::Struct;
  use Class::MakeMethods::Emulator::Struct; 
  struct ( ... );
  
  # Equivalent to use Class::MethodMaker( ... );
  use Class::MakeMethods::Emulator::MethodMaker( ... );
  
  # Equivalent to use base 'Class::Inheritable';
  use base 'Class::MakeMethods::Emulator::Inheritable';
  MyClass->mk_classdata( ... );
  
  # Equivalent to use base 'Class::AccessorFast';
  use base 'Class::MakeMethods::Emulator::AccessorFast';
  MyClass->mk_accessors(qw(this that whatever));


=head1 DESCRIPTION

In several cases, Class::MakeMethods provides functionality closely
equivalent to that of an existing module, and it is simple to map
the existing module's interface to that of Class::MakeMethods.

Class::MakeMethods::Emulator provides emulators for Class::MethodMaker,
Class::Accessor::Fast, Class::Data::Inheritable, Class::Singleton,
and Class::Struct, each of which passes the original module's test
suite, usually requiring only a single-line change.

More than demonstrating compatibility, these emulators also generally demonstrate the procedure for migrating to direct use of Class::MakeMethods.


=head1 INSTALLATION

You should be able to install this module using the CPAN shell interface:

  perl -MCPAN -e 'install Class::MakeMethods::Emulator'

If this module has not yet been posted to your local CPAN mirror,
you may also retrieve the current distribution from the below
address and follow the normal "gunzip", "tar xf", "cd", "perl Makefile.PL && make test && sudo make install" procedure or your local equivalent:

  http://www.evoscript.org/Class-MakeMethods/

=head2 Beta Release

This is the first release of these modules separated from the core Class::MakeMethods distribution. Please let me know if the upgrade causes you any difficulties.

=head2 Discussion and Support

There is not currently any offical discussion and support forum for this pacakage. 

If you have questions or feedback about this module, please feel
free to contact the author at the below address.


=head1 VERSION

This is version 1.003 of Class::MakeMethods::Emulator. 


=head1 SEE ALSO

See L<Class::MakeMethods::Emulator::Struct>, included in this distribution, and L<Class::Struct>, on CPAN.

See L<Class::MakeMethods::Emulator::AccessorFast>, included in this distribution, and L<Class::Accessor::Fast>, on CPAN.

See L<Class::MakeMethods::Emulator::Inheritable>, included in this distribution, and L<Class::Data::Inheritable>, on CPAN.

See L<Class::MakeMethods::Emulator::MethodMaker>, included in this distribution, and L<Class::MethodMaker>, on CPAN.

See L<Class::MakeMethods::Emulator::Singleton>, included in this distribution, and L<Class::Singleton>, on CPAN.


=head1 CREDITS AND COPYRIGHT

=head2 Developed By

  M. Simon Cavalletto, simonm@cavalletto.org
  Evolution Softworks, www.evoscript.org

=head2 Copyright

Copyright 2002 Matthew Cavalletto. 

Portions Copyright 2001 Evolution Online Systems, Inc.

=head2 Source Material

Based on Class::Accessor::Fast, developed by Michael G Schwern. Portions Copyright 2000 Michael G Schwern.

Based on Class::Data::Inheritable, developed by Damian Conway and Michael G Schwern. Portions Copyright 2000 Damian Conway and Michael G Schwern.

Based on Class::MethodMaker, originally developed by Peter Seibel, Organic Online. Portions Copyright 2000 Martyn J. Pearce. Portions Copyright 1996 Organic Online

Based on Class::Singleton, developed by Andy Wardley, abw@cre.canon.co.uk. Portions 1998 Canon Research Centre Europe Ltd. 

Based on Class::Struct.

=head2 License

You may use, modify, and distribute this software under the same terms as Perl.

=cut


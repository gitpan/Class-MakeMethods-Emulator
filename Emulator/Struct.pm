package Class::MakeMethods::Emulator::Struct;

use strict;

use Class::MakeMethods;

use vars qw(@ISA @EXPORT);
require Exporter;
push @ISA, qw(Exporter);
@EXPORT = qw(struct);

sub import {
  my $self = shift;
  
  if ( @_ == 0 ) {
    $self->export_to_level( 1, $self, @EXPORT );
  } elsif ( @_ == 1 ) {
    $self->export_to_level( 1, $self, @_ );
  } else {
    &struct;
  }
}

########################################################################

my %type_map = ( 
  '$' => 'scalar', 
  '@' => 'array', 
  '%' => 'hash',
  '_' => 'object',
);

sub struct {
  my ($class, @decls);
  my $base_type = ref $_[1] ;
  if ( $base_type eq 'HASH' ) {
      $base_type = 'Standard::Hash';
      $class = shift;
      @decls = %{shift()};
      _usage_error() if @_;
  }
  elsif ( $base_type eq 'ARRAY' ) {
      $base_type = 'Standard::Array';
      $class = shift;
      @decls = @{shift()};
      _usage_error() if @_;
  }
  else {
      $base_type = 'Standard::Array';
      $class = (caller())[0];
      @decls = @_;
  }
  _usage_error() if @decls % 2 == 1;
  
  my @rewrite;
  while ( scalar @decls ) {
    my ($name, $type) = splice(@decls, 0, 2);
    push @rewrite, $type_map{$type} 
      ? ( $type_map{$type} => { 'name'=>$name, auto_init=>1 } )
      : ( $type_map{'_'}   => { 'name'=>$name, 'class'=>$type, auto_init=>1 } );
  }
  Class::MakeMethods->make( 
    -TargetClass => $class,
    -MakerClass => $base_type,
    "new" => 'new', 
     @rewrite
  );
}

sub _usage_error {
  require Carp;
  Carp::confess "struct usage error";
}

########################################################################

1;

__END__

=head1 NAME

Class::MakeMethods::Emulator::Struct - Emulate Class::Struct


=head1 SYNOPSIS

  use Class::MakeMethods::Emulator::Struct; 
  
  struct ( 
      simple  => '$',
      ordered => '@', 
      mapping => '%',
      obj_ref => 'FooObject' 
  );


=head1 DESCRIPTION

This module emulates the functionality of Class::Struct by munging the provided field-declaration arguments to match those expected by Class::MakeMethods.

It supports the same four types of accessors, the choice of array-based or hash-based objects, and the choice of installing methods in the current package or a specified target. 


=head1 EXAMPLE

The below three declarations create equivalent methods for a simple hash-based class with a constructor and four accessors.

  use Class::Struct;
  struct ( 
      simple  => '$',
      ordered => '@', 
      mapping => '%',
      obj_ref => 'FooObject' 
  );
  
  use Class::MakeMethods::Emulator::Struct; 
  struct ( 
      simple  => '$',
      ordered => '@', 
      mapping => '%',
      obj_ref => 'FooObject' 
    );
  
  use Class::MakeMethods ( 
      -MakerClass		=> 'Standard::Array',
      'new'			=> 'new',
      'scalar'			=> 'simple',
      'array -auto_init 1'	=> 'ordered', 
      'hash -auto_init 1'	=> 'mapping',
      'object -auto_init 1'	=> '-class FooObject obj_ref' 
    );

=head1 COMPATIBILITY

This module aims to offer a "95% compatible" drop-in replacement for the core Class::Struct module for purposes of comparison and code migration. 

The C<class-struct.t> test for the core Class::Struct module is included with this package. The test is unchanged except for the a direct substitution of this emulator's name in the place of the core module.

However, there are numerous internal differences between the methods generated by the original Class::Struct and this emulator, and some existing code may not work correctly without modification. 


=head1 SEE ALSO

See L<Class::Struct> for documentation of the original module.

See L<Class::MakeMethods::Standard::Hash> and L<Class::MakeMethods::Standard::Array> for documentation of the created methods.

See L<Class::MakeMethods> for an overview of the method-generation
framework this is based on.

See L<Class::MakeMethods::Emulator::ReadMe> for distribution, installation,
version and support information.

=cut


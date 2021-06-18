package Repository::Request;

use header;
use Moose;
use Types;
use Model::Request;

with 'Repository::Role::Repository';

use constant {
	_model => 'Model::Request',
	_model_type => Types::InstanceOf['Model::Request'],
	_class => Model::Request->get_result_class,
};

sub get_awaiting ($self)
{
	return [
		$self->dbc->resultset($self->_class)->search({
			status => Model::Request->STATUS_AWAITING,
		})
	];
}

sub get_items ($self, $model)
{
	my $result = $self->get_by_id($model, 1, prefetch => 'items');

	return [
		map { $_->item } $result->items
	];
}

sub add_items ($self, $model, $items)
{
	my $result = $self->get_by_id($model, 1);

	for my $item ($items->@*) {
		$self->create_related(items => {item => $item});
	}

	return;
}

__PACKAGE__->meta->make_immutable;

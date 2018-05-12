<?php

namespace AppBundle\Validator\Constraints;

use Symfony\Component\Validator\Constraint;

/**
 * @Annotation
 */
class ConstraintSlug extends Constraint
{
    public $message = 'The slug "{{ string }}" contains an illegal character: it can only contain lowercase letters, numbers or - .';

    public function validatedBy()
    {
        return get_class($this).'Validator';
    }
}

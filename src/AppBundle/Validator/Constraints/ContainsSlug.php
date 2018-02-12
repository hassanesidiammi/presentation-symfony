<?php
/**
 * Created by PhpStorm.
 * User: Hassane SIDI AMMI
 * Date: 12/02/2018
 */

namespace AppBundle\Validator\Constraints;

use Symfony\Component\Validator\Constraint;

/**
 * Class ContainsSlug
 *
 * @Annotation
 */
class ContainsSlug extends Constraint
{
    public $message = 'The Slug "{{ string }}" contains an illegal character: it can only contain lowercase letters or numbers or "-".';
}
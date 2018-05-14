<?php

namespace AppBundle\Form;

use AppBundle\Entity\Post;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\Extension\Core\Type\CheckboxType;
use Symfony\Component\Form\Extension\Core\Type\DateType;
use Symfony\Component\Form\Extension\Core\Type\FileType;
use Symfony\Component\Form\Extension\Core\Type\TextareaType;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\Form\FormEvent;
use Symfony\Component\Form\FormEvents;
use Symfony\Component\OptionsResolver\OptionsResolver;

class PostType extends AbstractType
{
    /**
     * {@inheritdoc}
     */
    public function buildForm(FormBuilderInterface $builder, array $options)
    {
        $builder
            ->add('title', TextType::class)
            ->add('slug', TextType::class)
            ->add('imageFile', FileType::class, array(
                'label'      => 'Image',
                'required'   => false,
            ))
            ->addEventListener(FormEvents::PRE_SET_DATA, function (FormEvent $event){
                /** @var Post $post */
                $post = $event->getData();
                if(!empty($post->getImage())) {
                    $event->getForm()->add('deleteImage', CheckboxType::class, array(
                        'mapped' => false,
                        'required' => false,
                    ));
                }
            })
            ->add('editorial', TextareaType::class, array(
                'required' => false,
            ))
            ->add('body', TextareaType::class, array(
                'required' => true,
            ))
            ->add('createdAt', DateType::class)
            ->add('publishedAt', DateType::class, array(
                'required' => false,
            ))
        ;
    }

    /**
     * {@inheritdoc}
     */
    public function configureOptions(OptionsResolver $resolver)
    {
        $resolver->setDefaults(array(
            'data_class' => 'AppBundle\Entity\Post'
        ));
    }

    /**
     * {@inheritdoc}
     */
    public function getBlockPrefix()
    {
        return '_post';
    }

}

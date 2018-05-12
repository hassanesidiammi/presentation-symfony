<?php

namespace AppBundle\Controller;

use AppBundle\Entity\Post;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;

class PostController extends Controller
{
    public function indexAction()
    {
        $em = $this->getDoctrine()->getManager();

        $posts = $em->getRepository('AppBundle:Post')->findAll();

        return $this->render('post/index.html.twig', array(
            'posts' => $posts,
        ));

        return $this->render('post/index.html.twig', array());
    }

    public function newAction(Request $request)
    {
        return $this->render('post/new.html.twig', array(
        ));
    }

    public function showAction(Post $post)
    {
        return $this->render('post/show.html.twig', array(
            'post' => $post,

        ));
    }

    public function editAction(Request $request, Post $post)
    {
        return $this->render('post/edit.html.twig', array(
            'post' => $post,
        ));
    }

    public function deleteAction()
    {
        return $this->render('post/delete.html.twig', array());
    }
}

<?php

// This file has been auto-generated by the Symfony Dependency Injection Component for internal use.

if (\class_exists(\ContainerHsn3va1\appDevDebugProjectContainer::class, false)) {
    // no-op
} elseif (!include __DIR__.'/ContainerHsn3va1/appDevDebugProjectContainer.php') {
    touch(__DIR__.'/ContainerHsn3va1.legacy');

    return;
}

if (!\class_exists(appDevDebugProjectContainer::class, false)) {
    \class_alias(\ContainerHsn3va1\appDevDebugProjectContainer::class, appDevDebugProjectContainer::class, false);
}

return new \ContainerHsn3va1\appDevDebugProjectContainer();
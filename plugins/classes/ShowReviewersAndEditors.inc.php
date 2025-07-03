<?php

class ShowReviewersAndEditors {
    public static function registerHooks() {
        // Inject the form data
        HookRegistry::register('PublicationForm::initData', [self::class, 'initData']);
        HookRegistry::register('PublicationForm::readUserVars', [self::class, 'readUserVars']);
        HookRegistry::register('PublicationForm::execute', [self::class, 'saveData']);

        // Add checkboxes to the backend UI (Schedule for Publication form)
        HookRegistry::register('Templates::Controllers::Grid::Publication::Form::MetadataForm::Fields', [self::class, 'addCheckboxFields']);
    }

    public static function initData($hookname, &$args) {
        $form = &$args[0];
        $publication = $form->publication;

        $form->setData('show_reviewers', $publication->getData('show_reviewers'));
        $form->setData('show_editors', $publication->getData('show_editors'));

        return false;
    }

    public static function readUserVars($hookname, &$args) {
        $uservars = &$args[1];
        $uservars[] = 'show_reviewers';
        $uservars[] = 'show_editors';

        return false;
    }

    public static function saveData($hookname, &$args) {
        $form = &$args[0];
        $publication = $form->publication;

        $publication->setData('show_reviewers', $form->getData('show_reviewers'));
        $publication->setData('show_editors', $form->getData('show_editors'));

        return false;
    }

    public static function addCheckboxFields($hookname, &$args) {
        error_log('addCheckboxFields triggered!');
        $smarty = $args[0];
        $output = &$args[2];

        $output .= $smarty->fetch('plugins/themes/sahadeva/templates/components/showReviewersAndEditors.tpl');
        return false;
    }
}
<?php

import('classes.submission.SubmissionDAO');

class SahadevaSubmissionDAO extends SubmissionDAO {
    public function getByIds(array $ids) {
        if(empty($ids)) return [];

        $placeholders = implode(',', array_fill(0, count($ids), '?'));
        $results = $this->retrieve(
            "SELECT * FROM submissions WHERE submission_id IN ($placeholders)",
            $ids,
        );

        $submissions = [];
        foreach($results as $result) {
            $submissions[] = (array) $result;
        }

        print_r($submissions);
        return $submissions;
    }
}
<?php

import ('classes.submission.SubmissionDAO');

class SahadevaSubmissionDAO extends SubmissionDAO {
    /**
     * Get multiple submissions by their IDs
     * 
     * @param array $ids
     * @return array<int, Submission>
     */
    public function getByIds(array $ids) {
        if(empty($ids)) return [];

        $placeholders = implode(',', array_fill(0, count($ids), '?'));

        $sql = 'SELECT * FROM submissions WHERE submission_id IN (' . $placeholders . ')';
        $result = $this->retrieve($sql, $ids);

        $submissions = [];
        foreach($result as $row) {
            $rowArray = (array) $row;
            $submission = $this->_fromRow($rowArray);
            $submissions[$submission->getId()] = $submission;
        }

        return $submissions;
    }
}
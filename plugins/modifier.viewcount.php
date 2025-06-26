<?php

function smarty_modifier_viewcount($number) {
    if ($number < 1000) return (string)$number;
    if ($number < 10000) return number_format($number / 1000, 1) . 'k';
    if ($number < 1000000) return floor($number / 1000) . 'k';
    if ($number < 10000000) return number_format($number / 1000000, 1) . 'M';
    return floor($number / 1000000) . 'M';
}
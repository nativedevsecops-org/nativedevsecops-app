<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

/**
 * @property int $id
 * @property string $name
 */
class JobCircular extends Model
{
    protected $fillable = [
        'name',
        'type',
        'slug',
        'location_type',
        'experience',
        'vacancy',
        'salary_range',
        'address',
        'description',
        'responsibilities',
        'requirement',
        'about_company',
    ];

    public function applications(): HasMany
    {
        return $this->hasMany(JobApplication::class);
    }
}

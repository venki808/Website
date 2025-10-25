<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class User extends Model
{
    use SoftDeletes;
    protected $table = 'users';
    protected $fillable = ['user_name','password','email'];
    protected $hidden = ['password'];
    public $timestamps = true;
}

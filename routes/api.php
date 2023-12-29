<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers;
use Kreait\Firebase\Exception\Auth\FailedToVerifyToken;
use Kreait\Laravel\Firebase\Facades\Firebase;

/* test hello */
Route::get('/hello', function () {
    return 'hello';
});

/* test api */
Route::post('/checktoken', function (Request $request) {
    //echo $request;
    $response = (object) [];
    $token = $request->bearerToken(); 
    $response->token = $token;

    $auth = app('firebase.auth');

    try {
        $verifiedIdToken = $auth->verifyIdToken($token);
        //echo var_dump($verifiedIdToken);
    } catch (FailedToVerifyToken $e) {
        echo 'The token is invalid: '.$e->getMessage();
    }

    /* check token payload */
    $email = $verifiedIdToken->claims()->get('email');
    $response->payload_email = $email;
    $uid = $verifiedIdToken->claims()->get('sub');
    $response->payload_uid = $uid;

    /* check authenticated user */
    $user = $auth->getUser($uid);
    $response->authenticated_user = $user;

    return response()->json($response, 200);

});
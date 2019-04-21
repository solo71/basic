<?php

use yii\helpers\Html;
use yii\widgets\ActiveForm;
use yii\helpers\Url;

/* @var $this yii\web\View */
/* @var $model app\models\Users */
/* @var $form \app\models\CreateForm */

?>

<div class="users-form">

    <?php $form = ActiveForm::begin(); ?>

    <?php
    $form->field($model, 'id')->hiddenInput()->label(false);
    ?>

    <?= $form->field($model, 'username')->textInput(['maxlength' => true]) ?>

    <?= $form->field($model, 'password')->textInput(['maxlength' => true]) ?>

    <div class="form-group">
        <?= Html::a(Yii::t('app', 'Back'), Url::to(['/site/index']), ['class' => 'btn btn-default']) ?>
        <?= Html::submitButton('Регистрация', ['class' => 'btn btn-success']) ?>    </div>

    <?php $form->end(); ?>

</div>



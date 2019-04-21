<?php

use app\models\User;
use yii\helpers\Html;
use yii\helpers\Url;
use yii\web\View;
use yii\widgets\ActiveForm;


/* @var $this yii\web\View */
/* @var $model app\models\User */
/* @var $form yii\widgets\ActiveForm */
?>

<div class="user-form">

    <?php $form = ActiveForm::begin(); ?>

    <?php
    if ($action == 'create') {
        $form->field($model, 'id')->hiddenInput()->label(false);
    } else {
        $form->field($model, 'id')->input('number', ['disabled' => true]);
    }
    ?>

    <?= $form->field($model, 'username')->textInput(['maxlength' => true]) ?>
    <?= $form->field($model, 'password')->textInput(['maxlength' => true]) ?>

    <?php
    // Если используется не сценарий создания пользователя
    if (!$action == 'create') {
        ?>
        <div class="form-group">
            <?= Html::a(
                Yii::t('app/user', 'Change password'),
                Url::toRoute(['/backend/user/change-password', 'id' => $model->id]),
                ['class' => 'btn btn-info']
            ) ?>
        </div>
        <div class="form-group">
            <?= Html::a(
                Yii::t('app/user', 'Change user role'),
                Url::to(['/permit/user/view', 'id' => $model->id]),
                ['class' => 'btn btn-info']
            ) ?>
        </div>
        <?php
    }
    ?>
    <div class="form-group">
        <?= Html::a(Yii::t('app', 'Back'), Url::to(['/backend/user/index']), ['class' => 'btn btn-default']) ?>
        <?= ($action == 'update') ? Html::resetButton(Yii::t('app', 'Reset'), ['class' => 'btn btn-warning']) : null ?>
        <?= Html::submitButton($model->isNewRecord
            ? Yii::t('app', 'Create')
            : Yii::t('app', 'Save')
            , ['class' => $model->isNewRecord ? 'btn btn-success' : 'btn btn-primary']) ?>
    </div>

    <?php ActiveForm::end(); ?>

</div>

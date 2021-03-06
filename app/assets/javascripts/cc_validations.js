
/////////////////////////////////////////////////////////////
// Validations
/////////////////////////////////////////////////////////////


$(document).ready(function() {
    

    $('#credit-card-form').bootstrapValidator({
      submitButtons: 'null',
      fields: {
        'user[cc_name]': {
          message: 'The name field is not valid',
          validators: {
            notEmpty: {
              message: 'The name field can\'t be empty'
            }
          }
        },
        'user[cc_number]': {
          message: 'The credit card number is not valid',
          validators: {
            notEmpty: {
              message: 'credit card number can\'t be empty'
            },
            creditCard: {
              message: 'The credit card number is not valid'
          }
          }
        },
        'user[exp_month]': {
          message: 'expiration month not valid',
          validators: {
            notEmpty: {
              message: 'expiration month required'
            }
          }
        },
        'user[exp_year]': {
          message: 'expiration year not valid',
          validators: {
            notEmpty: {
              message: 'expiration year required'
            }
          }
        },
        'user[cc_cvc]': {
          message: 'cvc not valid',
          validators: {
            notEmpty: {
              message: 'CVC required'
            }
          },
          stringLength: {
            min: 3,
            max: 3,
            message: 'CVC must be 3 digits'
          }
        },
        'user[promo_code]': {
          message: '',
          validators: {
          }
        },
        'user[referrer]': {
          message: '* this field is required',
          validators: {
            notEmpty: {
              message: '* this field is required'
            }
          }
        }
      }
    });
  });





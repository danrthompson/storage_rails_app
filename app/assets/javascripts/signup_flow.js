
/////////////////////////////////////////////////////////////
// Validations
/////////////////////////////////////////////////////////////
$(document).ready(function() {

  $('#signup-form')
    .bootstrapValidator({
    // To use feedback icons, ensure that you use Bootstrap v3.1.0 or later
    feedbackIcons: {
      // valid: 'glyphicon glyphicon-ok',
      // invalid: 'glyphicon glyphicon-remove',
      // validating: 'glyphicon glyphicon-refresh'
    },
    fields: {
      'user[address_line_1]': {
        message: 'The address field is not valid',
        validators: {
          notEmpty: {
            message: 'The address field can\'t be empty'
          },
          stringLength: {
            min: 10,
            message: 'The address must be a real'
          },
        }
      },
      'user[city]': {
        message: 'The city field is not valid',
        validators: {
          notEmpty: {
            message: 'The city is required'
          },  
          stringLength:{
            min: 2,
            message: "Valid city is required"
          }
        }
      },
      'user[zip]': {
        message: 'The zip code field is not valid',
        validators: {
          notEmpty: {
            message: 'zip required'
          },
          stringLength: {
            min: 5,
            max: 5,
            message: ' valid zip required'
          },
        }
      },
      'user[state]': {
        message: 'The state field is not valid',
        validators: {
          notEmpty: {
            message: '* state required.'
          },
          stringLength: {
            min:2,
            message: "Valid state required"
          }
        }
      },
      'user[phone_number]': {
        message: 'The address field is not valid',
        validators: {
          notEmpty: {
            message: 'The phone number is required'
          },
          stringLength: {
            min: 10,
            message: 'The address must be a real phone number'
          },
        }
      },
      'user[password]': {
        message: 'The password field is not valid',
        validators: {
          stringLength: {
          min: 8,
          message: 'The password must have at least 8 characters'
          }
         }
      },
      'user[password_confirmation]': {
        message: 'The password_confirmation field is not valid',
        validators: {
          identical: {
            field: 'user[password]',
            message: 'The password confirmation must match the password'
          }
         }
      }
    }
  })
});






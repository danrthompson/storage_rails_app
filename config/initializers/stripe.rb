Rails.configuration.stripe = {
  publishable_key: 'pk_test_IisHI7ZxJJdvj6jcuqOKIQ6a',
  secret_key: 'sk_test_CGn5ko7pgIHhyey4kJi33Pcn'
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
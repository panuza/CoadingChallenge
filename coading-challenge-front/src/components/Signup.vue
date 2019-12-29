<template>
  <div class="m-auto my-8 text-center pt-5">
    <div class="border pt-5 p-10 mt-5 border-grey-light shadow rounded col-md-4 offset-md-4 wrapper fadeInDown">
      <h3 class="text-2xl mb-6 text-grey-darkest w-100">Sign Up</h3>
      <form @submit.prevent="signup" class="w-75">
        <div class="text-red" v-if="error">{{ error }}</div>
        <div class="mb-6">
          <input type="text" v-model="first_name" class="input" id="first_name" required="required" placeholder="First Name">
        </div>
        <div class="mb-6">
          <input type="text" v-model="last_name" class="input" id="last_name" required="required" placeholder="Last Name">
        </div>
        <div class="mb-6">
          <input type="email" v-model="email" class="input" id="email" required="required" placeholder="Email">
        </div>
        <div class="mb-6 pt-2">
          <input type="password" v-model="password" class="input" id="password" required="required" placeholder="Password">
        </div>
        <div class="mb-6 pt-2">
          <input type="password" v-model="password_confirmation" class="input" required="required" id="password_confirmation" placeholder="Password Confirmation">
        </div>
        <input type="submit" class="fadeIn fourth mt-3" value="Sign up"></input>
      </form>

    </div>
  </div>
</template>

<script>
export default {
  name: 'Signup',
  data () {
    return {
      first_name: '',
      last_name: '',
      email: '',
      password: '',
      password_confirmation: '',
      error: ''
    }
  },
  created () {
    this.checkedSignedIn()
  },
  updated () {
    this.checkedSignedIn()
  },
  methods: {
    signup () {
      this.$http.plain.post('/signup', { first_name: this.first_name, last_name: this.last_name, email: this.email, password: this.password, password_confirmation: this.password_confirmation })
        .then(response => this.signupSuccessful(response))
        .catch(error => this.signupFailed(error))
    },
    signupSuccessful (response) {
      localStorage.csrf = response.data.csrf
      localStorage.auth_token = response.data.jwt
      localStorage.signedIn = true
      this.error = ''
      this.$router.replace('/challenges')
    },
    signupFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.error) || 'Something went wrong'
      delete localStorage.csrf
      delete localStorage.signedIn
    },
    checkedSignedIn () {
      if (localStorage.signedIn) {
        this.$router.replace('/challenges')
      }
    }
  }
}
</script>
<style>


</style>


<template>
  <div class="m-auto my-8 text-center pt-5">
    <div class="border pt-5 p-10 mt-5 border-grey-light shadow rounded col-md-4 offset-md-4 wrapper fadeInDown">
      <h3 class="text-2xl mb-6 text-grey-darkest w-100">Sign Up</h3>
      <form @submit.prevent="signup" class="w-75">
        <div class="text-red" v-if="error">{{ error }}</div>
        <div class="mb-6">
          <input type="text" v-model="first_name" class="input" id="first_name" placeholder="First Name">
        </div>
        <div class="mb-6">
          <input type="text" v-model="last_name" class="input" id="last_name" placeholder="Last Name">
        </div>
        <div class="mb-6">
          <input type="email" v-model="email" class="input" id="email" placeholder="Email">
        </div>
        <div class="mb-6 pt-2">
          <input type="password" v-model="password" class="input" id="password" placeholder="Password">
        </div>
        <div class="mb-6 pt-2">
          <input type="password" v-model="password_confirmation" class="input" id="password_confirmation" placeholder="Password Confirmation">
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
      if (!response.data.csrf) {
        this.signupFailed(response)
        return
      }

      localStorage.csrf = response.data.csrf
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


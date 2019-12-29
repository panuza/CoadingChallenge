<template>
  <div class="m-auto my-8 text-center pt-5">
    <div class="border pt-5 p-10 mt-5 border-grey-light shadow rounded col-md-4 offset-md-4 wrapper fadeInDown">
      <h3 class="text-2xl mb-6 text-grey-darkest w-100">Sign In</h3>
      <form @submit.prevent="signin" class="w-75">
        <div class="text-red" v-if="error">{{ error }}</div>
        <div class="mb-6">
          <input type="email" v-model="email" class="input" id="email" placeholder="Email">
        </div>
        <div class="mb-6 pt-2">
          <input type="password" v-model="password" class="input" id="password" placeholder="Password">
        </div>
        <input type="submit" class="fadeIn fourth mt-3" value="Log In"></input>
      </form>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Signin',
  data () {
    return {
      email: '',
      password: '',
      error: ''
    }
  },
  created () {
    // window.location.reload(true);
    this.checkSignedIn()
  },
  updated () {
    this.checkSignedIn()
  },
  methods: {
    signin () {
      this.$http.plain.post('/signin', { email: this.email, password: this.password })
        .then(response => this.signinSuccessful(response))
        .catch(error => this.signinFailed(error))
    },
    signinSuccessful (response) {
      localStorage.csrf = response.data.csrf
      localStorage.token = response.data.jwt
      localStorage.signedIn = true
      this.error = ''
      this.$router.replace('/challenges')
    },
    signinFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.error) || ''
      delete localStorage.csrf
      delete localStorage.signedIn
    },
    checkSignedIn () {
      if (localStorage.signedIn) {
        this.$router.replace('/challenges')
      }
    }
  }
}
</script>
<style></style>

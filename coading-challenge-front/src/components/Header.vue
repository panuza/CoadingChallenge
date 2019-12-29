<template>
  <header class="back-color py-4">
    <div class="container m-auto flex flex-wrap items-center justify-end">
      <div class="w-100 row">
        <div class="text-left col-md-4"><h3><strong class="text-white">Coading Challenge</strong></h3></div>
        <div class="text-right col-md-8">
          <router-link to="/" class="link-grey px-2 no-underline text-right text-white" v-if="!signedIn()">Log In</router-link>
          <router-link to="/signup" class="link-grey px-2 no-underline text-right text-white" v-if="!signedIn()">Sign Up</router-link>
          <router-link to="/challenges" class="link-grey px-2 no-underline text-right text-white" v-if="signedIn()">Challenges</router-link>
          <router-link to="Api/challenges/top" class="link-grey px-2 no-underline text-right text-white" v-if="signedIn()">Top Challenges</router-link>
          <a href="#" @click.prevent="signOut" class="link-grey px-2 no-underline text-right text-white" v-if="signedIn()">Sign out</a>
        </div>
      </div>
    </div>
  </header>
</template>

<script>
export default {
  name: 'Header',
  created () {
    this.signedIn()
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    signedIn () {
      return localStorage.signedIn
    },
    signOut () {
      this.$http.secured.delete('/signin')
        .then(response => {
          delete localStorage.csrf
          delete localStorage.signedIn
          this.$router.replace('/')
        })
        .catch(error => this.setError(error, 'Cannot sign out'))
    }
  }
}
</script>
<style>
  .back-color {
    background-color: green;
  }
  .text-white{
    color: #ffffff;
  }
</style>

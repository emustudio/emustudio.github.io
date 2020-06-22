---
layout: roadmap
title: Roadmap
permalink: /roadmap/
---

<div class="jumbotron">
<h1>Roadmap</h1>
<div class="table-responsive">
  <table class="table">
    <tr>
      <td>Next milestone:</td><th>{{ site.data.roadmap.next_milestone }}</th>
    </tr>
    <tr>
      <td>Open issues:</td><td><span id="issuesOpen"></span></td>
    </tr>
    <tr>
      <td>Closed issues:</td><td><span id="issuesClosed"></span></td>
    </tr>
    <tr>
      <td>All issues:</td><td><span id="issuesAll"></span></td>
    </tr>
  </table>
</div>
</div>


Most of the future plans of emuStudio are represented either by issues [at GitHub]({{ site.data.roadmap.github_url }}/issues),
or they are kind-of ad-hoc. All Issues _should be_ collected into [milestones]({{ site.data.roadmap.github_url }}/milestones).

# 5 Latest activities

The following list shows 5 latest activities in emuStudio overall.

<div id="feed"></div>

<script>
  GitHubActivity.feed({
    username: "{{ site.data.roadmap.github_username }}",
    repo: "{{ site.data.roadmap.github_repository }}",
    selector: "#feed",
    limit: 5, // optional
    milestone: {{ site.data.roadmap.milestone_number }}, // only for issues
    openSelector: "#issuesOpen",
    closedSelector: "#issuesClosed",
    allSelector: "#issuesAll"
  });
</script>

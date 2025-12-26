# Multi-Tenant LMS GraphQL API

This is a robust, multi-tenant Learning Management System (LMS) built as a Rails API-only application. It uses GraphQL for all operations and implements row-level data isolation to ensure that multiple schools can operate independently on a single database instance.

## 🚀 Features

* **Multi-Tenancy:** Automated school isolation using subdomains (e.g., `stanford.lvh.me`) and row-level scoping via `school_id`.
* **GraphQL API:** A single endpoint handling complex queries and mutations for Users, Courses, and Enrollments.
* **Stateless Authentication:** JWT-based authentication using Devise and `devise-jwt` with token revocation (denylist).
* **Role-Based Authorization:** Strict permission management using CanCanCan for three distinct roles: User, Instructor, and Admin.
* **School Switching:** Middleware-driven school context setting based on the incoming request subdomain.

---

## 🛠 Tech Stack

* **Framework:** Ruby on Rails (API-only)
* **Database:** PostgreSQL (with row-level foreign key isolation)
* **API:** GraphQL (via `graphql-ruby`)
* **Auth:** Devise + JWT
* **Authorization:** CanCanCan

---

## 🏗 Data Model & Permissions

### School Association Tree

All models are scoped to a `school_id` to maintain strict tenant isolation.

### User Roles

| Role | Permissions |
| --- | --- |
| **User** | Read courses, view/update own profile, view own enrollments. |
| **Instructor** | All User abilities + manage course content and view school enrollments. |
| **Admin** | Full CRUD (Create, Read, Update, Delete) for all school resources. |

---

## 🚦 Getting Started

### Prerequisites

* Ruby 3.2.2+
* PostgreSQL
* A tool to manage local subdomains (e.g., editing your `/etc/hosts` file or using `lvh.me`).

### Installation

1. **Clone the repository:**
```bash
git clone https://github.com/yourusername/multi-tenant-lms.git
cd multi-tenant-lms

```


2. **Install dependencies:**
```bash
bundle install

```


3. **Setup the database:**
  Configre database.yml first
```bash
rails db:create
rails db:migrate
rails db:seed

```


*The seed file creates 2 schools, 18 users (3 per role per school), and 6 courses.*
4. **Local Subdomain Setup:**
Ensure your local environment recognizes subdomains. You can use `http://school1.lvh.me:3000` for testing.
5. **Start the server:**
```bash
rails s

```



---

## 🧪 API Usage & Testing

### Authentication Flow

1. **Sign In:** Send a `signIn` mutation to receive a JWT.
2. **Authorization Header:** Include the token in subsequent requests as a Bearer token:
`Authorization: Bearer <your_token>`

### Example Mutation: Create Course (Admin Only)

```graphql
mutation {
  createCourse(input: { title: "CS101", description: "Intro to Computer Science" }) {
    course {
      id
      title
    }
    errors
  }
}

```

### Example Query: Get Own Enrollments

```graphql
query {
  enrollments {
    id
    course {
      title
    }
  }
}

```

---

## 📝 Project Structure

* `app/controllers/graphql_controller.rb`: Handles authentication and sets the execution context.
* `app/models/ability.rb`: Centralized authorization rules.
* `app/graphql/mutations/`: Explicitly authorized CRUD operations.

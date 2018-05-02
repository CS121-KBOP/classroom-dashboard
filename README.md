# Classroom Dashboard - KBOP

Classroom Dashboard is a web-based, ruby on rails platform to help professors manage in-classroom interaction. The dashboard complements existing lecture methods, giving professors a suite of tools to help them better engage their classes. These tools include equity cards to randomly call on students, polls for real-time feedback, and image assignments for participation. Classroom Dashboard takes advantage of all the technology already in classrooms to turn distractions into educational assets.

## Architecture

### Prerequisites

1. Git
2. Ruby 2.5.0 or later
3. Rails 5.0 or later
4. ImageMagick libraries (can be acquired either by downloading the binaries or using downloaders like MacPorts or Apt-Get)

### Gems

1. omniauth, for Google OAuth integration
2. chartkick, for JS chart generation
3. bootstrap-sass, for frontend templating
4. jquery-rails, for frontend JS libraries
5. paperclip, for image management

## Installation

1. Clone the repository
```shell
> cd /path/to/my/folder
> git clone https://github.com/CS121-KBOP/classroom-dashboard.git
> cd classroom-dashboard
```
2. Install Gems
```shell
> bundle install
```
3. Set up the Database
```shell
> rails db:migrate
```
4. Run the server
```shell
> rails server
```
5. Go to localhost:3000 and log in with your Google account.


## Functionality

When you first load the main page, there are two sections. One is an box for students, another is a login button for professors. Click the login button and select or sign into your Google account. You will be taken to an empty list of courses. Click "New Course" in the top right corner, and enter your course's title, code, section, semester, and year. Click confirm, and you will be taken to the main course page. However, the course needs students. Click "Student Roster" in the main toolbar to be taken to the currently-empty roster page. You can add students individually by clicking "Add Student" in the top right corner. For faster creation, you can use the dropzone. Create a series of image files, where the name of the file is the name of the student (replacing spaces with underscores). Then, drag these images into the dropzone and press "Import." The students will be automatically created. From here, you have several features to use in lectures.

##### Equity cards
Select "Equity Cards" from the toolbar. In the middle of the page is the card display. Click anywhere on the box or on the "Draw Flashcard" button to select a random student. To the right of the card is a button labeled "Order Students." Clicking that button reveals a text box. You can enter any number of student names, each on a new line. Clicking submit will store that ordering. Now, the flashcards will show the students in the order you specified. One that list is exhausted, the cards will be random again. Unrecognized names will be ignored. On the Student Roster page, unchecking "Include in flashcards" next to a student and pressing "confirm" will exclude that student from random selection.

##### Face/Name Quizzes
You can also use flashcards to quiz yourself on names and faces. Select "Face/Name Quiz" from the toolbar to go to the quiz. Here, you can click on the image or on the draw flashcard button to see a new face. Clicking on the empty space below or on the "Show/Hide Info" button will display or toggle the name. Showing the name also displays a notes box. Anything typed in the notes box is stored with that student automatically. Students can also be excluded from the quiz in the same way as Equity Cards, using the "Include in quiz" checkboxes on the Student Roster Page.

##### Assignments
Assignment allow you to collect image submissions from students. Click on "Assignments" in the toolbar to see a list of assignments, and select "New Assignment" to create a new one. Enter in the name and a short description, and click confirm. You will be taken to the assignment's page, which will show a 5-letter access tag near the top. A student can enter that tag into the box on the front page to access the assignment. There, they can search for and select their name, upload an image and submit. The page shows you which students have submitted, and clicking on a name on the table takes you to that student's submission. You can also use the arrows above the submission display to look through all of the submissions. You can edit an assignment to enable or disable it. Disabled assignments cannot be submitted to.

##### Polls
Polls operate much like assignments. Click on "Polls" in the toolbar to see a list and to create a new poll. The poll page has a table of options. Click "Add Option" to create a new option, and give it a short code and a description. You can add as many options as you'd like. The poll page also shows an access tag, which students use to reach the poll and select their choice. When they do, the charts at the bottom will auto-update to show the current votes.



## Known Problems / Future Work
1. Dropzones are currently unreliable, with a suspected race condition. If you drag-and-drop images into the dropzone, and then wait, many will produce long error messages and fail to upload. The dropzone js code is in the javascripts folder, and is borrowed code. The JS should be calling the import function in the student controller. This entire section of code could be replaced, perhaps with the JQuery File Uploader (https://github.com/blueimp/jQuery-File-Upload)
2. There have been strange bugs with JQuery onload or onready functions not being called when a page is first loaded. As a temporary fix, these functions are instead called from within script tags on their relevant pages. This smells bad.
3. There are insufficient tests for most controllers, especially with batch upload, CRUD functionality, deletion dependencies, and other potential failure points.
4. Page styling is a bit inconsistent. Some points of note: header text alignment, icon usage, and table row clickability.
5. The bar chart on the poll page has rounding errors in the x-axis tick values. These will always be integer values anyways, so the tick marks should not show floats.
6. On the student roster page, the exclusion from flashcard checkboxes should all be one form, with a single submit button. Alternativly, they could use JQuery/AJAX so that each change auto-updates the relevant student, without the need for a form.
7. It might be worth it to add the ability to upload students via CSV, in a different sort of batch upload. This functionality was already added, and then removed. See https://github.com/CS121-KBOP/classroom-dashboard/pull/15 for details.


## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D


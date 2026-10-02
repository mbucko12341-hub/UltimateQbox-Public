window.addEventListener('message', function(event) {
    let data = event.data;
    if (data.action === 'open') {
        $('#cityhall-container').removeClass('hidden');
        updateClock();
        
        if (data.jobs) {
            let container = $('#jobs-grid-container');
            container.empty();
            
            data.jobs.forEach(job => {
                let isDanger = job.danger === true;
                let cardClass = isDanger ? 'fancy-card highlight-card' : 'fancy-card';
                let btnClass = isDanger ? 'fancy-btn danger-btn' : 'fancy-btn';
                let btnText = isDanger ? 'Resign Contract' : 'Sign Contract';
                let iconAction = isDanger ? 'fa-solid fa-right-from-bracket' : 'fa-solid fa-arrow-right-long';

                let cardHtml = `
                    <div class="${cardClass}">
                        <div class="card-glow"></div>
                        <div class="card-icon-wrapper">
                            <i class="${job.icon}"></i>
                        </div>
                        <div class="card-info">
                            <h3>${job.label}</h3>
                            <p>${job.desc}</p>
                        </div>
                        <button class="${btnClass}" onclick="selectJob('${job.name}')">
                            <span>${btnText}</span>
                            <i class="${iconAction}"></i>
                        </button>
                    </div>
                `;
                container.append(cardHtml);
            });
        }
    } else if (data.action === 'close') {
        $('#cityhall-container').addClass('hidden');
    }
});

function updateClock() {
    let now = new Date();
    let hours = String(now.getHours()).padStart(2, '0');
    let minutes = String(now.getMinutes()).padStart(2, '0');
    $('#time-display').text(`${hours}:${minutes}`);
}
setInterval(updateClock, 1000);

// Navigation tab switches
$('.nav-item').click(function() {
    $('.nav-item').removeClass('active');$(this).addClass('active');

    let targetTab = $(this).data('tab');
    $('.content-pane').removeClass('active');$('#' + targetTab + '-tab').addClass('active');
});

// FIXED: Event delegation for close button so it triggers reliably
$(document).on('click', '#close-btn', function() {
    $.post('https://bucko_cityhall/close', JSON.stringify({}));
});

// ESC key to close
document.onkeyup = function(data) {
    if (data.which === 27) {
        $.post('https://bucko_cityhall/close', JSON.stringify({}));
    }
};

function requestDoc(docType) {
    $.post('https://bucko_cityhall/requestDocument', JSON.stringify({
        docType: docType
    }));
}

function selectJob(jobName) {
    $.post('https://bucko_cityhall/setJob', JSON.stringify({
        jobName: jobName
    }));
}
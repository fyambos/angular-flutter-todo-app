import { Component, EventEmitter, Input, Output } from '@angular/core';
import { TaskState } from 'src/app/models/task.model';
import { LanguageService } from 'src/app/services/language.service';

@Component({
  selector: 'app-search-bar',
  templateUrl: './search-bar.component.html',
})
export class SearchBarComponent {
  TaskState = TaskState;
  searchTerm = '';
  currentState = 'ALL';
  @Input() showDeleteIcon = false;
  @Output() search = new EventEmitter<string | undefined>();
  @Output() add = new EventEmitter<void>();
  @Output() delete = new EventEmitter<void>();
  @Output() state = new EventEmitter<string>();
  constructor(private languageService: LanguageService) { }

  get placeholder(): string {
    return this.languageService.translate('search.placeholder');
  }

  getStateDisplay(): string {
    return this.languageService.translate(`task.state.${this.currentState}`);
  }

  get stateDisplayMap(): { [key in TaskState]: string } {
    return {
      [TaskState.DONE]: this.languageService.translate('task.state.DONE'),
      [TaskState.TODO]: this.languageService.translate('task.state.TODO'),
      [TaskState.DOING]: this.languageService.translate('task.state.DOING'),
      [TaskState.CANCELLED]: this.languageService.translate('task.state.CANCELLED'),
    };
  }

  get fieldTranslation(): string {
    return this.languageService.translate('task.state.ALL');
  }

  submitSearch = () => {
    this.search.emit(this.searchTerm);
  }

  switchSate = (state: string) => {
    this.currentState = state;
    this.state.emit(state);
  }

  addNewTask = () => {
    this.add.emit();
  }
}

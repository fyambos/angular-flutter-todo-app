import { Component, EventEmitter, Inject, Input, OnInit, Output } from '@angular/core';
import { AbstractControl, FormBuilder, FormControl, FormGroup, ValidationErrors, ValidatorFn, Validators } from '@angular/forms';
import { MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Task, TaskState } from 'src/app/models/task.model';
import { LanguageService } from 'src/app/services/language.service'; 

@Component({
  selector: 'app-edit-task',
  templateUrl: './edit-task.component.html',
})
export class EditTaskComponent {

  TaskStatus = TaskState;
  form: FormGroup;

  constructor(
    private readonly fb: FormBuilder,
    private languageService: LanguageService,
    @Inject(MAT_DIALOG_DATA) public data: { task: Task }
  ) {
    this.form = this.fb.group({
      id: new FormControl(data?.task?.id),
      title: new FormControl(data?.task?.title, [Validators.required]),
      description: new FormControl(data?.task.description, [Validators.required]),
      state: new FormControl(data?.task.state ?? 'TODO', [Validators.required]),
      startDate: new FormControl(data?.task.startDate ?? new Date(), [Validators.required, this.dateValidator()]),
      endDate: new FormControl(data?.task.endDate ?? new Date(), [Validators.required, this.dateValidator()]),
    });
  }

  dateValidator(): ValidatorFn {
    return (control: AbstractControl): ValidationErrors | null => {
      const currentDate = new Date();
      currentDate.setHours(0, 0, 0, 0);
      const selectedDate = new Date(control.value);
      selectedDate.setHours(0, 0, 0, 0);
      if (selectedDate < currentDate) {
        return { invalidDate: 'Date cannot be in the past' };
      }
      return null;
    };
  }

  getTranslation(key: string): string {
    return this.languageService.translate(key);
  }
  getStateDisplay(state: TaskState): string {
    return this.languageService.translate(`task.state.${state}`);
  }
}

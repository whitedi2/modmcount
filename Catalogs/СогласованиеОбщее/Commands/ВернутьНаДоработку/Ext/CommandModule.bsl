﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	// Вставить содержимое обработчика.
	// ПараметрыФормы = Новый Структура("", );
	// ОткрытьФорму("Документ.Д_ЗаявкаНаОплату.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	ТипОбъекта = ?(ТипЗнч(ПараметрКоманды) = Тип("ДокументСсылка.Д_ЗаявкаНаОплату"), "документа", "документа");
	БП = БПСервер.НайтиТекущийБПСервер(ПараметрКоманды);
	
	Если НЕ БП = Неопределено Тогда
		БПВФинальнойСтадии = БюджетныйНаСервере.ВернутьРеквизит(БП, "Завершен") ИЛИ БПСервер.СравнитьСтадию("Действие5", ПараметрКоманды) ИЛИ БПСервер.СравнитьСтадию("Действие3", ПараметрКоманды);
		
		Если ТипЗнч(ПараметрКоманды) = Тип("ДокументСсылка.Д_ЗаявкаНаОплату") Тогда
			Если БюджетныйНаСервере.ВернутьРеквизит(БП, "Завершен") Тогда
				//Если ПлатитРКО(ПараметрКоманды) Тогда
					Если  Вопрос("Заявка принята к оплате. Возможность отменить заявку имеет только """ + Решальщик() + """.
						|Отправить ему запрос о согласовании отмены заявки?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да  Тогда
						ПричинаОтмены = "";
						Если ВвестиСтроку(ПричинаОтмены, "Причина возврата заявки на доработку:") Тогда
							ОтправитьПросьбу(ПараметрКоманды, ПричинаОтмены);
						КонецЕсли;
					КонецЕсли;
				//ИначеЕсли НЕ БПСервер.ПолучитьМассивПользователей().Найти(Решальщик()) = Неопределено Тогда
				//	СогласоватьОтменуЗаявки(БП, ПараметрКоманды);
				//	Предупреждение("Заявка успешно возвращена на оплату.");
				//	ОповеститьОбИзменении(ПараметрКоманды);
				//	ОповеститьОбИзменении(Тип("СправочникСсылка.Задача"));
				Иначе	
					Предупреждение("Бизнес процесс уже завершен. Возврат на доработку невозможен.");
				//КонецЕсли;
				Возврат;
			КонецЕсли;
			
		Иначе	
			Если БПВФинальнойСтадии Тогда
				Предупреждение("Бизнес процесс уже завершен, либо находится на исполнении. Возврат на доработку невозможен.");
				Возврат;
			КонецЕсли;
		КонецЕсли;
		
		Если БПСервер.СравнитьСтадию("Действие1", ПараметрКоманды) Тогда
			Предупреждение("Возврат на доработку можно произвести из текущих задач.");
			Возврат;
		КонецЕсли;
		
		МассивТекПользователей = БПСервер.ПолучитьМассивПользователей();
		ЕстьАдминистратор = Ложь;
		ЕстьОФК = Ложь;
		
		Для Каждого ТекПользователь Из МассивТекПользователей Цикл
			
			Если БюджетныйНаСервере.РольДоступнаСервер("ОФК") Тогда 
				ЕстьОФК = Истина;
			КонецЕсли;
			
			Если БюджетныйНаСервере.РольДоступнаСервер("Администратор") Тогда 
				ЕстьАдминистратор = Истина;
			КонецЕсли;
			
		КонецЦикла;
		
		Если МассивТекПользователей.Найти(БюджетныйНаСервере.ВернутьРеквизит(ПараметрКоманды, "Автор")) = Неопределено И Не ЕстьОФК И Не ЕстьАдминистратор Тогда
			Предупреждение("Вы не являетесь автором данного " + ТипОбъекта + ", поэтому принудительный возврат на доработку невозможен.");
			Возврат;
		КонецЕсли;
		
		ТекФорма = ПолучитьФорму("Справочник.СогласованиеОбщее.Форма.ФормаВозвратаНаДоработку", Новый Структура("БизнесПроцесс, ТекЗаявка", БП, ПараметрКоманды));
		Если НЕ ПараметрыВыполненияКоманды.Источник.ИмяФормы = "РегистрСведений.ВнутренниеДокументы.Форма.ФормаСписка" Тогда
			ТекФорма.РазрешитьРедактирвованиеДокумента = Истина;		
		КонецЕсли;
		ТекФорма.Открыть();
		
		//Если Вопрос("Вы уверены что хотите вернуть на доработку: 
		//	|" + Строка(ПараметрКоманды) + "?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да  Тогда
		//	
		//	//ИзменитьЗадачу(БП, ПараметрКоманды);
		//	//ОповеститьОбИзменении(ПараметрКоманды);
		//	//ОповеститьОбИзменении(Тип("СправочникСсылка.Задача"));
		//КонецЕсли;
	Иначе
		Предупреждение("Бизнес-процесс не найден!");
	КонецЕсли;
КонецПроцедуры


&НаСервере
Процедура ИзменитьЗадачу(ТекБп, ТекЗаявка)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	Задача.Ссылка,
	|	Задача.Исполнитель
	|ИЗ
	|	Справочник.Задача КАК Задача
	|ГДЕ
	|	Задача.БизнесПроцесс = &БизнесПроцесс
	|	И Задача.Выполнена = ЛОЖЬ
	|	И Задача.ПометкаУдаления = ЛОЖЬ";
	
	Запрос.УстановитьПараметр("БизнесПроцесс", ТекБп);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Комментарий = "Пользователь " + Строка(ПараметрыСеанса.ТекущийПользователь) + " вернул объект на доработку.";
	//меняем маршрут
	ТекБПОбъект = ТекБп.ПолучитьОбъект();
	ЭтоПроверкаКонтрагента = Ложь;
	Пока Выборка.Следующий() Цикл
		Если ТипЗнч(Выборка.Ссылка.Заявка) = Тип("СправочникСсылка.Контрагенты") Тогда
			ЗадачаПроверкиКонтрагента = Выборка.Ссылка.ПолучитьОбъект();
			ЗадачаПроверкиКонтрагента.БизнесПроцесс = Неопределено;
			ЗадачаПроверкиКонтрагента.Записать();
			ЭтоПроверкаКонтрагента = Истина;
			Прервать;
		КонецЕсли;	
		СтруктураОтбора = Новый Структура("СубъектСогласования", Выборка.Исполнитель);
		ОтобранныеСтроки = ТекБПОбъект.ДопСогласование.НайтиСтроки(СтруктураОтбора);
		Для каждого ТекСтрока Из ОтобранныеСтроки Цикл
			ТекСтрока.Пользователь = ПараметрыСеанса.ТекущийПользователь;
			ТекСтрока.Согласовано = Ложь;
			ТекСтрока.Пройден = Истина;
		КонецЦикла;
	КонецЦикла;
	ТекБПОбъект.Записать();
	
	//выполняем задачу 
	Если ЭтоПроверкаКонтрагента Тогда
		НоваяЗадача = Справочники.Задача.СоздатьЭлемент();
		НоваяЗадача.Автор = ПараметрыСеанса.ТекущийПользователь;
		НоваяЗадача.Дата = ТекущаяДата();
		НоваяЗадача.ДатаНачала = ТекущаяДата();
		НоваяЗадача.Наименование = "Отправить заявку";
		НоваяЗадача.Исполнитель = ТекБп.Автор;
		НоваяЗадача.БизнесПроцесс = ТекБп;
		НоваяЗадача.ТочкаМаршрута = Перечисления.Согласование1ТочкиМаршрута.Действие1;
		НоваяЗадача.Предприятие = ТекЗаявка.Предприятие;
		НоваяЗадача.Описание = "Доработать заявку на оплату: " + ТекЗаявка;
		НоваяЗадача.Заявка = ТекЗаявка;
		НоваяЗадача.Записать();
	Иначе	
		Выборка.Сбросить();
		Пока Выборка.Следующий() Цикл
			БПСервер.ВыполнитьЗадачу(Выборка.Ссылка, 0, "", Комментарий);
		КонецЦикла;
	КонецЕсли;
	
	ТекЗаявкаОбъект = ТекЗаявка.ПолучитьОбъект();
	ТекЗаявкаОбъект.СостояниеДокумента = Перечисления.Д_СостоянияДокументов.НаДоработке;
	ТекЗаявкаОбъект.Записать();
	
	
	
	
КонецПроцедуры

&НаСервере
Функция Решальщик()
	
	Возврат Справочники.Пользователи.ПустаяСсылка();
	
КонецФункции // Решальщик()

&НаСервере
Процедура СогласоватьОтменуЗаявки(ТекБп, ТекЗаявка)
	ТекБпОбъект = ТекБп.ПолучитьОбъект();
	ТекБпОбъект.Завершен = Ложь;
	Плательщик = Константы.СотрудникРКО.Получить();
	
	Комментарии = Строка(ТекущаяДата()) + ": " + ПараметрыСеанса.ТекущийПользователь + 
	" по запросу РКО вернул(а) заявку с оплаты:
	|";
	ТекБпОбъект.Комментарии = ТекБпОбъект.Комментарии + "
	|" + Комментарии;
	
	
	ТекБпОбъект.Записать();
	
	Задача = Справочники.Задача.СоздатьЭлемент();		
	Задача.Заявка = ТекЗаявка;
	Задача.Дата = ТекущаяДата();
	Задача.Предприятие = ТекБп.Предприятие;
	Задача.Наименование = "Оплатить заявку повторно " + Строка(Плательщик);
	
	Задача.БизнесПроцесс  = ТекБп;
	Задача.ТочкаМаршрута  = Перечисления.Согласование1ТочкиМаршрута.Действие5;
	
	Задача.Автор = ПараметрыСеанса.ТекущийПользователь;
	Задача.Описание = ТекБп.Описание;	
	Задача.Исполнитель = Плательщик;
	
	Задача.Записать();
	
	ТекЗаявкаОбъект = ТекЗаявка.ПолучитьОбъект();
	ТекЗаявкаОбъект.СостояниеДокумента = Перечисления.Д_СостоянияДокументов.НаИсполнении;
	ТекЗаявкаОбъект.Записать();
КонецПроцедуры

&НаСервере
Процедура ОтправитьПросьбу(ПараметрКоманды, ПричинаОтмены)
	
	МассивОповещаний = Новый Массив;
	
	
	МассивОповещаний.Добавить(Справочники.Пользователи.ПустаяСсылка());
	
	НачатьТранзакцию();
	Для каждого Пользователь Из МассивОповещаний Цикл
		
		БПСервер.СоздатьОповещение(Пользователь, "Пользователь " + Строка(ПараметрыСеанса.ТекущийПользователь) 
		+ " просит отменить " + Строка(ПараметрКоманды) + ". 
		|Причина: " + ПричинаОтмены + ".", "Оповещение: запрос на отмену заявки №" + Строка(ПараметрКоманды.Номер), ПараметрКоманды, Истина);	
		
	КонецЦикла;
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры









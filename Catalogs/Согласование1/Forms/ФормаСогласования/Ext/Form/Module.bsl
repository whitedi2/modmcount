﻿&НаКлиенте
Процедура ЗаявкаСогласована(Команда)
	
	Если БюджетныйНаКлиенте.ЗадачаВыполнена(Объект) Тогда
	    Возврат;	
	КонецЕсли;
	
	
	УдалениеПустых();
	
	Если НЕ БюджетныйНаКлиенте.СогласоватьБизнесПроцесс("согласовать данную заявку") Тогда
		Возврат;
	КонецЕсли; 
	//Если Записать() Тогда
		Если Не БПСервер.ПроверкаЗадачи(Объект.Ссылка) Тогда
			//Результат = ВыполненоСервер(Истина, Истина, Объект.Исполнитель);    //!!!
			Результат = БПСервер.ВыполнитьКомандуЗадачиБП(Объект.Ссылка, Команда.Имя, ПолучитьСтруктуруРеквизитовФормы());
			
			ОповеститьОбИзменении(Объект.Ссылка);
			Оповестить("ОбновитьСписокЗадач");
			Если Результат Тогда
				Закрыть();
				УстановитьЗначениеНаличияДоговора();
			Иначе
				БюджетныйНаКлиенте.УниверсальноеВыполнениеКоманды(Объект.Заявка, "");
			КонецЕсли;
			
		КонецЕсли;
	//КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УдалениеПустых()
	СписокУдаленных = новый Массив;
	Для каждого ТекСтрока Из ДопСогласование Цикл
		Если НЕ ЗначениеЗаполнено(ТекСтрока.СубъектСогласования) Тогда
			СписокУдаленных.Добавить(ТекСтрока);		
		КонецЕсли;
	КонецЦикла;
	
	Для каждого ТекУдаленнаяСтрока Из СписокУдаленных Цикл
		ДопСогласование.Удалить(ТекУдаленнаяСтрока);	
	КонецЦикла; 
	

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	БП = Объект.БизнесПроцесс.ПолучитьОбъект();
	ТЗ = БП.ДопСогласование.Выгрузить();
	ДопСогласование.Загрузить(ТЗ);
	ДопСогласованиеПервоначальное.Загрузить(ТЗ);
	
	ТЗИсполнение = БП.ДопИсполнение.Выгрузить();
	ДопИсполнение.Загрузить(ТЗИсполнение);
	ДопИсполнениеПервоначальное.Загрузить(ТЗИсполнение);
	
	ТЗОповещение = БП.ДопОповещение.Выгрузить();
	Адресаты.Загрузить(ТЗОповещение);
	АдресатыПервоначальное.Загрузить(ТЗОповещение);
	
	//ТочкаМаршрута = "Действие2";
	//Исполнитель = "";
	//ТекущийПользователь = БюджетныйНаСервере.ПолучитьПользователя();
	//ТекущаяДолжность = БюджетныйНаСервере.ПолучитьДолжностьПользователя();
	//Исполнитель = ТекущийПользователь;
	//Результат = Параметры.Свойство("Исполнитель", Исполнитель);
	//Должность = ТекущаяДолжность;
	//Результат = Параметры.Свойство("Должность", Должность);
	
	МассивПользователей = БПСервер.ПолучитьМассивПользователей();
	
	Если НЕ БПСервер.ТекПользовательИсполнительЗадачи(Объект.Ссылка) Тогда
		Элементы.ЗаявкаСогласована.Видимость = 0;
		Элементы.НаДоработку.Видимость = 0;
		//Элементы.Группа9.Видимость = Ложь;
		
		ЕстьВМаршруте = Ложь;  //Если пользователь в маршруте, то покажем декорации
		ДоступныеПользователи = БПСервер.ПолучитьМассивПользователей();
		БП = Объект.Ссылка.БизнесПроцесс;
		Для каждого ТекПользователь Из ДоступныеПользователи Цикл
			Если НЕ БП.ДопСогласование.Найти(ТекПользователь, "СубъектСогласования") = Неопределено Тогда
				ЕстьВМаршруте = Истина;			
			КонецЕсли;
		КонецЦикла;
		Элементы.ДекорацияИнформация.Видимость = ЕстьВМаршруте;
		Элементы.ДекорацияОтменаЗаявкиПояснение.Видимость = ЕстьВМаршруте;
	Иначе
		Элементы.ОтменаЗаявки.Видимость = Ложь;
		Элементы.ДекорацияИнформация.Видимость = Ложь;
		Элементы.ДекорацияОтменаЗаявкиПояснение.Видимость = Ложь;
	КонецЕсли;
	Результат = Параметры.Свойство("ТочкаМаршрута", ТочкаМаршрута);
	Объект.Комментарии = Объект.БизнесПроцесс.ПолучитьОбъект().Комментарии;
	
	АвторДокумента = Объект.Заявка.Автор;
	
	//Элементы.ЗадачаЗадачаУстановитьСрокВыполнения.Видимость = Не Объект.ВРаботе;
	сабОбщегоНазначения.ОбновитьКоличествоПрикрепленныхФайловСервер(ЭтаФорма);
	
	Если ЗначениеЗаполнено(Объект.Предприятие) Тогда
		Элементы.ДоговорОтсутствует.Видимость = ЕстьВозможностьИзменятьНалиичиеДоговора();
	Иначе 
		Элементы.ДоговорОтсутствует.Видимость = Ложь;
	КонецЕсли;	
	
КонецПроцедуры

 &НаКлиенте
Функция ПроверитьКомментарий()

	Если ПустаяСтрока(Комментарий) Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Необходимо заполнить комментарий!";
		Сообщение.Поле = "Комментарий";
		Сообщение.Сообщить();
		Возврат Истина;
	Иначе 
		Возврат Ложь;
	КонецЕсли;	
	
КонецФункции

&НаКлиенте
Процедура НаДоработку(Команда)
	
	УдалениеПустых();
	
	//ОтправляемыеРеквизитыФормы = ПолучитьСтруктуруРеквизитовФормы();
	//БПСервер.ВыполнитьКомандуСправочники(Объект.Ссылка, "НаДоработку", ОтправляемыеРеквизитыФормы);
	
	Если БюджетныйНаКлиенте.ЗадачаВыполнена(Объект) Тогда
	    Возврат;	
	КонецЕсли;
	Если НЕ БюджетныйНаКлиенте.СогласоватьБизнесПроцесс("отправить на доработку данную заявку") Тогда
		Возврат;
	КонецЕсли;
	
	//Если ПроверитьКомментарий() Тогда
	//	Возврат;
	//КонецЕсли;
	
	Если ПустаяСтрока(Комментарий) Тогда
		сабОбщегоНазначенияКлиентСервер.СообщитьОбОшибке(Объект,  "Не указана причина возврата на доработку",,, "Комментарий", Истина);
		Возврат;
	КонецЕсли;
	
	//Если Записать() Тогда
		Если Не БПСервер.ПроверкаЗадачи(Объект.Ссылка) Тогда
			//ВыполненоСервер(Ложь, Истина, Объект.Исполнитель);   //!!!
			БПСервер.ВыполнитьКомандуЗадачиБП(Объект.Ссылка, Команда.Имя, ПолучитьСтруктуруРеквизитовФормы());
			
			ОповеститьОбИзменении(Объект.Ссылка);
			Оповестить("ОбновитьСписокЗадач");
			Закрыть();
		КонецЕсли;
	//КонецЕсли;
	
	// оповестить о доработке
	БПСервер.ОповеститьОДоработке(Объект.БизнесПроцесс, Объект.Исполнитель, Комментарий);
	
КонецПроцедуры


&НаКлиенте
Процедура ОтменаЗаявки(Команда)
	УдалениеПустых();
	
	Если БюджетныйНаКлиенте.ЗадачаВыполнена(Объект) Тогда
	    Возврат;	
	КонецЕсли;
	
	
	Если НЕ БюджетныйНаКлиенте.СогласоватьБизнесПроцесс("отменить согласование по данной заявке") Тогда
		Возврат;
	КонецЕсли;
	
	Если ПустаяСтрока(Комментарий) И НЕ ВвестиСтроку(Комментарий, "Причина отмены заявки:") Тогда
		Возврат;
	КонецЕсли;
	//Если Записать() Тогда
		Если Не БПСервер.ПроверкаЗадачи(Объект.Ссылка) Тогда
			//ВыполненоСервер(Ложь, Ложь, Объект.Исполнитель);      //!!!
			БПСервер.ВыполнитьКомандуЗадачиБП(Объект.Ссылка, Команда.Имя, ПолучитьСтруктуруРеквизитовФормы());
			
			ОповеститьОбИзменении(Объект.Ссылка);
			Оповестить("ОбновитьСписокЗадач");
			Закрыть();
		КонецЕсли;
	//КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДопСогласованиеПередНачаломИзменения(Элемент, Отказ)
	ТекСтрока = Элементы.ДопСогласование.ТекущиеДанные;
	Если ТекСтрока.Пройден ИЛИ НЕ ТекСтрока.Автор = БюджетныйНаСервере.ПолучитьПользователя() И НЕ ПустаяСтрока(ТекСтрока.СубъектСогласования) Тогда
		Предупреждение("Невозможно редактирование строки.");		
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ДопСогласованиеПередУдалением(Элемент, Отказ)
	ТекСтрока = Элементы.ДопСогласование.ТекущиеДанные;
	Если ТекСтрока.Согласовано Тогда
		Предупреждение("Невозможно удалить строку, т.к. субъект " + Строка(ТекСтрока.СубъектСогласования) + " уже согласовал заявку.");
		Отказ = Истина;
	ИначеЕсли НЕ ТекСтрока.Автор = БюджетныйНаСервере.ПолучитьПользователя() Тогда
		//Если ПустаяСтрока(ТекСтрока.Автор) Тогда
		//	Предупреждение("Невозможно удалить строку, т.к. тип заявки требует согласование с указанным рецензентом.");		
		//Иначе
		//	Предупреждение("Невозможно удалить строку, т.к. ее добавил пользователь " + ТекСтрока.Автор  + ".");		
		//КонецЕсли;		
		//Отказ = Истина;
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура ДопСогласованиеПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	ТекСтрока = Элементы.ДопСогласование.ТекущиеДанные;
	ТекСтрока.Автор = БюджетныйНаСервере.ПолучитьПользователя(); 
КонецПроцедуры

&НаСервере
Функция Финансист()
	//Если ПараметрыСеанса.ТекущийПользователь.Должность = Справочники.Д_Должности.Финансист Тогда
	//	Возврат Истина;
	//Иначе
		Возврат Ложь;	
	//КонецЕсли; 
КонецФункции // ()

&НаСервере
Процедура Печать(ТабДок, ПараметрКоманды)
	Документы.Д_ЗаявкаНаОплату.Печать(ТабДок, ПараметрКоманды);
КонецПроцедуры

&НаСервере
Процедура ПроверкаСоответствия(ТабДок, ПараметрКоманды)
	Документы.Д_ЗаявкаНаОплату.ПроверкаСоответствия(ТабДок, ПараметрКоманды);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФайл(Команда)
	ОткрытьФорму("Справочник.Файлы.ФормаОбъекта", Новый Структура("Ключ", БюджетныйНаСервере.ВернутьРеквизит(Объект.Заявка, "Файл"))); 
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ЭтаФорма.ЗаблокироватьДанныеФормыДляРедактирования();		
	БПСервер.ЗаписатьДействиеПользователяВЛог(Объект.Ссылка, "ПриОткрытии");
КонецПроцедуры

&НаКлиенте
Процедура КонтрольДДС(Команда)
	БюджетныйНаКлиенте.УниверсальноеВыполнениеКоманды(Объект.Заявка, "Документ.Д_ЗаявкаНаОплату.Команда.ПроверкаСоответствияБюджету");
КонецПроцедуры

&НаКлиенте
Процедура ДопСогласованиеПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Если Копирование Тогда
		Отказ = Истина;	
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПечатьПлатежки(Команда)
	
	СтандартнаяОбработка = Ложь;
	
	ТабДок = Новый ТабличныйДокумент;
	
	ПечатьПлатежкиНаСервере(ТабДок, Объект.Заявка);

	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Ложь;
	ТабДок.ТолькоПросмотр = Истина;
	ТабДок.ОтображатьЗаголовки = Истина;
	ТабДок.ОтображатьГруппировки = Истина;
	ТабДок.АвтоМасштаб = Истина;
	ФормаПечати = ПолучитьФорму("ОбщаяФорма.ФормаПечатиДокумента");
	ФормаПечати.ТабДок = ТабДок;
	ФормаПечати.Открыть();

КонецПроцедуры

&НаСервере
Процедура ПечатьПлатежкиНаСервере(ТабДок, ПараметрКоманды)
	Документы.Д_ЗаявкаНаОплату.ПечатьПлатежки(ТабДок, ПараметрКоманды);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ЗакрытьФормуСправочники" Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПолучитьУжеСозданныеСправочники(БП)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Задача.Ссылка
	|ИЗ
	|	Справочник.Задача КАК Задача
	|ГДЕ
	|	Задача.БизнесПроцесс = &БизнесПроцесс";
	Запрос.УстановитьПараметр("БизнесПроцесс", БП);
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат Новый Массив;
	Иначе
		Возврат Результат.Выгрузить().ВыгрузитьКолонку("Ссылка");
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ЗадвоениеЗадач(БП, МассивУжеСозданных)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Задача.ПометкаУдаления,
	|	Задача.БизнесПроцесс,
	|	Задача.ТочкаМаршрута,
	|	Задача.Наименование,
	|	Задача.Выполнена,
	|	Задача.Заявка,
	|	Задача.Предприятие,
	|	Задача.Автор,
	|	Задача.ДатаНачала,
	|	Задача.ДатаИсполнения,
	|	Задача.РезультатВыполнения,
	|	Задача.Пользователь,
	|	Задача.Гиперссылка,
	|	Задача.ОткрыватьФорму,
	|	Задача.Новая,
	|	Задача.СрокВыполнения,
	|	Задача.НеДелегировать,
	|	Задача.ВРаботе,
	|	Задача.ДокументОбязательныйКПрикреплению,
	|	Задача.Исполнитель,
	|	Задача.Должность,
	|	СУММА(1) КАК КоличествоЗадач
	|ПОМЕСТИТЬ Вт_НачДанные
	|ИЗ
	|	Справочник.Задача КАК Задача
	|ГДЕ
	|	НЕ Задача.Ссылка В (&СписокЗадач)
	|	И Задача.БизнесПроцесс = &БизнесПроцесс
	|
	|СГРУППИРОВАТЬ ПО
	|	Задача.ДатаНачала,
	|	Задача.ДатаИсполнения,
	|	Задача.РезультатВыполнения,
	|	Задача.Пользователь,
	|	Задача.Гиперссылка,
	|	Задача.ОткрыватьФорму,
	|	Задача.ПометкаУдаления,
	|	Задача.Выполнена,
	|	Задача.Заявка,
	|	Задача.Предприятие,
	|	Задача.Автор,
	|	Задача.ДокументОбязательныйКПрикреплению,
	|	Задача.Исполнитель,
	|	Задача.Должность,
	|	Задача.БизнесПроцесс,
	|	Задача.ТочкаМаршрута,
	|	Задача.Наименование,
	|	Задача.Новая,
	|	Задача.СрокВыполнения,
	|	Задача.НеДелегировать,
	|	Задача.ВРаботе
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Вт_НачДанные.КоличествоЗадач
	|ИЗ
	|	Вт_НачДанные КАК Вт_НачДанные
	|ГДЕ
	|	Вт_НачДанные.КоличествоЗадач > 1";
	Запрос.УстановитьПараметр("СписокЗадач", МассивУжеСозданных);
	Запрос.УстановитьПараметр("БизнесПроцесс", БП);
	
	Результат = Запрос.Выполнить();

	Возврат Не Результат.Пустой();
	
КонецФункции	

&НаСервере
Функция ПолучитьСтруктуруРеквизитовФормы()
	Возврат БПСервер.ПолучитьСтруктуруРеквизитовФормы(ЭтаФорма);
КонецФункции

&НаСервере
Процедура УстановитьЗначениеНаличияДоговора()

	Если Не ДоговорОтсутствует Тогда
		Возврат;
	КонецЕсли;	
	
	Набор = РегистрыСведений.ДополнительныеСведения.СоздатьНаборЗаписей();
	Набор.Отбор.Объект.Установить(Объект.Заявка);
	Набор.Отбор.Свойство.Установить(ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.ДоговорОтсутствует);
	
	Запись = Набор.Добавить();
	Запись.Свойство = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.ДоговорОтсутствует;
	Запись.Значение = ДоговорОтсутствует;
	Запись.Объект   = Объект.Заявка;
	
	Набор.Записать();
	
КонецПроцедуры

&НаСервере
Функция ЕстьВозможностьИзменятьНалиичиеДоговора()
	
	ЗначениеСвойства = сабОбщегоНазначения.ПолучитьЗначениеСвойства(ПараметрыСеанса.ТекущийПользователь, ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.ОтветствененЗаПроверкуДоговоровВЗаявкахНаОплату);
	Если ЗначениеСвойства = Неопределено Тогда
		Возврат Ложь;
	Иначе 
		Возврат ЗначениеСвойства;
	КонецЕсли;	
	
КонецФункции	

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	БПСервер.ЗаписатьДействиеПользователяВЛог(Объект.Ссылка, "ПослеЗаписи");
КонецПроцедуры

&НаКлиенте
Процедура ПечатьЗаявки(Команда)
	
	БюджетныйНаКлиенте.УниверсальноеВыполнениеКоманды(Объект.Заявка, "");
	
КонецПроцедуры
